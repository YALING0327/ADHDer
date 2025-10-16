/**
 * 七牛云对象存储服务
 * 用于替代AWS S3，提供更优惠的价格和国内更快的访问速度
 */

import qiniu from 'qiniu';
import nconf from 'nconf';

// 七牛云配置
const accessKey = nconf.get('QINIU_ACCESS_KEY');
const secretKey = nconf.get('QINIU_SECRET_KEY');
const bucket = nconf.get('QINIU_BUCKET') || 'adhder-storage';
const cdnDomain = nconf.get('QINIU_CDN_DOMAIN'); // 例如：http://cdn.adhder.com

// 初始化认证和配置
const mac = new qiniu.auth.digest.Mac(accessKey, secretKey);
const config = new qiniu.conf.Config();

// 华东区域配置
config.zone = qiniu.zone.Zone_z0;

/**
 * 生成上传凭证
 * @param {string} key - 文件保存路径，如果为null则生成通用凭证
 * @param {number} expires - 凭证有效期（秒），默认1小时
 * @returns {string} 上传凭证
 */
export function getUploadToken(key = null, expires = 3600) {
  const options = {
    scope: key ? `${bucket}:${key}` : bucket,
    expires,
  };
  const putPolicy = new qiniu.rs.PutPolicy(options);
  return putPolicy.uploadToken(mac);
}

/**
 * 上传本地文件
 * @param {string} localFile - 本地文件路径
 * @param {string} key - 文件保存路径（如：avatars/user123.jpg）
 * @returns {Promise<Object>} 上传结果
 */
export async function uploadFile(localFile, key) {
  return new Promise((resolve, reject) => {
    const formUploader = new qiniu.form_up.FormUploader(config);
    const putExtra = new qiniu.form_up.PutExtra();
    const uploadToken = getUploadToken(key);

    formUploader.putFile(uploadToken, key, localFile, putExtra, (err, body, info) => {
      if (err) {
        console.error('七牛云上传失败:', err);
        reject(err);
      } else if (info.statusCode === 200) {
        console.log(`✅ 文件上传成功: ${key}`);
        resolve({
          success: true,
          url: `${cdnDomain}/${body.key}`,
          key: body.key,
          hash: body.hash,
          size: body.fsize,
        });
      } else {
        console.error(`七牛云上传失败: HTTP ${info.statusCode}`);
        reject(new Error(`Upload failed with status code: ${info.statusCode}`));
      }
    });
  });
}

/**
 * 上传Buffer数据
 * @param {Buffer} buffer - 文件内容Buffer
 * @param {string} key - 文件保存路径
 * @returns {Promise<Object>} 上传结果
 */
export async function uploadBuffer(buffer, key) {
  return new Promise((resolve, reject) => {
    const formUploader = new qiniu.form_up.FormUploader(config);
    const putExtra = new qiniu.form_up.PutExtra();
    const uploadToken = getUploadToken(key);

    formUploader.put(uploadToken, key, buffer, putExtra, (err, body, info) => {
      if (err) {
        console.error('七牛云上传失败:', err);
        reject(err);
      } else if (info.statusCode === 200) {
        console.log(`✅ Buffer上传成功: ${key}`);
        resolve({
          success: true,
          url: `${cdnDomain}/${body.key}`,
          key: body.key,
          hash: body.hash,
        });
      } else {
        console.error(`七牛云上传失败: HTTP ${info.statusCode}`);
        reject(new Error(`Upload failed with status code: ${info.statusCode}`));
      }
    });
  });
}

/**
 * 上传Stream数据
 * @param {Stream} readableStream - 可读流
 * @param {string} key - 文件保存路径
 * @returns {Promise<Object>} 上传结果
 */
export async function uploadStream(readableStream, key) {
  return new Promise((resolve, reject) => {
    const formUploader = new qiniu.form_up.FormUploader(config);
    const putExtra = new qiniu.form_up.PutExtra();
    const uploadToken = getUploadToken(key);

    formUploader.putStream(uploadToken, key, readableStream, putExtra, (err, body, info) => {
      if (err) {
        console.error('七牛云上传失败:', err);
        reject(err);
      } else if (info.statusCode === 200) {
        console.log(`✅ Stream上传成功: ${key}`);
        resolve({
          success: true,
          url: `${cdnDomain}/${body.key}`,
          key: body.key,
          hash: body.hash,
        });
      } else {
        console.error(`七牛云上传失败: HTTP ${info.statusCode}`);
        reject(new Error(`Upload failed with status code: ${info.statusCode}`));
      }
    });
  });
}

/**
 * 删除文件
 * @param {string} key - 文件路径
 * @returns {Promise<Object>} 删除结果
 */
export async function deleteFile(key) {
  return new Promise((resolve, reject) => {
    const bucketManager = new qiniu.rs.BucketManager(mac, config);

    bucketManager.delete(bucket, key, (err, respBody, respInfo) => {
      if (err) {
        console.error('七牛云删除失败:', err);
        reject(err);
      } else if (respInfo.statusCode === 200) {
        console.log(`✅ 文件删除成功: ${key}`);
        resolve({ success: true });
      } else {
        console.error(`七牛云删除失败: HTTP ${respInfo.statusCode}`);
        reject(new Error(`Delete failed with status code: ${respInfo.statusCode}`));
      }
    });
  });
}

/**
 * 批量删除文件
 * @param {Array<string>} keys - 文件路径数组
 * @returns {Promise<Object>} 删除结果
 */
export async function deleteFiles(keys) {
  return new Promise((resolve, reject) => {
    const bucketManager = new qiniu.rs.BucketManager(mac, config);

    // 构建批量删除操作
    const deleteOps = keys.map(key => qiniu.rs.deleteOp(bucket, key));

    bucketManager.batch(deleteOps, (err, respBody, respInfo) => {
      if (err) {
        console.error('七牛云批量删除失败:', err);
        reject(err);
      } else if (respInfo.statusCode === 200) {
        console.log(`✅ 批量删除成功: ${keys.length}个文件`);
        resolve({
          success: true,
          results: respBody,
        });
      } else {
        console.error(`七牛云批量删除失败: HTTP ${respInfo.statusCode}`);
        reject(new Error(`Batch delete failed with status code: ${respInfo.statusCode}`));
      }
    });
  });
}

/**
 * 获取文件信息
 * @param {string} key - 文件路径
 * @returns {Promise<Object>} 文件信息
 */
export async function getFileInfo(key) {
  return new Promise((resolve, reject) => {
    const bucketManager = new qiniu.rs.BucketManager(mac, config);

    bucketManager.stat(bucket, key, (err, respBody, respInfo) => {
      if (err) {
        console.error('获取文件信息失败:', err);
        reject(err);
      } else if (respInfo.statusCode === 200) {
        resolve({
          success: true,
          info: {
            size: respBody.fsize,
            hash: respBody.hash,
            mimeType: respBody.mimeType,
            putTime: respBody.putTime,
          },
        });
      } else {
        reject(new Error(`Get file info failed with status code: ${respInfo.statusCode}`));
      }
    });
  });
}

/**
 * 生成私有文件访问链接（如果Bucket是私有的）
 * @param {string} key - 文件路径
 * @param {number} expires - 链接有效期（秒），默认1小时
 * @returns {string} 私有访问URL
 */
export function getPrivateUrl(key, expires = 3600) {
  const deadline = Math.floor(Date.now() / 1000) + expires;
  const privateUrl = qiniu.rs.makePrivateDownloadUrl(mac, cdnDomain, key, deadline);
  return privateUrl;
}

/**
 * 复制文件
 * @param {string} srcKey - 源文件路径
 * @param {string} destKey - 目标文件路径
 * @returns {Promise<Object>} 复制结果
 */
export async function copyFile(srcKey, destKey) {
  return new Promise((resolve, reject) => {
    const bucketManager = new qiniu.rs.BucketManager(mac, config);

    bucketManager.copy(bucket, srcKey, bucket, destKey, (err, respBody, respInfo) => {
      if (err) {
        console.error('七牛云复制失败:', err);
        reject(err);
      } else if (respInfo.statusCode === 200) {
        console.log(`✅ 文件复制成功: ${srcKey} -> ${destKey}`);
        resolve({ success: true });
      } else {
        console.error(`七牛云复制失败: HTTP ${respInfo.statusCode}`);
        reject(new Error(`Copy failed with status code: ${respInfo.statusCode}`));
      }
    });
  });
}

/**
 * 移动/重命名文件
 * @param {string} srcKey - 源文件路径
 * @param {string} destKey - 目标文件路径
 * @returns {Promise<Object>} 移动结果
 */
export async function moveFile(srcKey, destKey) {
  return new Promise((resolve, reject) => {
    const bucketManager = new qiniu.rs.BucketManager(mac, config);

    bucketManager.move(bucket, srcKey, bucket, destKey, (err, respBody, respInfo) => {
      if (err) {
        console.error('七牛云移动失败:', err);
        reject(err);
      } else if (respInfo.statusCode === 200) {
        console.log(`✅ 文件移动成功: ${srcKey} -> ${destKey}`);
        resolve({ success: true });
      } else {
        console.error(`七牛云移动失败: HTTP ${respInfo.statusCode}`);
        reject(new Error(`Move failed with status code: ${respInfo.statusCode}`));
      }
    });
  });
}

/**
 * 列出文件
 * @param {string} prefix - 文件前缀
 * @param {string} marker - 分页标记
 * @param {number} limit - 返回数量限制，默认1000
 * @returns {Promise<Object>} 文件列表
 */
export async function listFiles(prefix = '', marker = '', limit = 1000) {
  return new Promise((resolve, reject) => {
    const bucketManager = new qiniu.rs.BucketManager(mac, config);

    bucketManager.listPrefix(bucket, {
      prefix,
      marker,
      limit,
    }, (err, respBody, respInfo) => {
      if (err) {
        console.error('七牛云列表查询失败:', err);
        reject(err);
      } else if (respInfo.statusCode === 200) {
        resolve({
          success: true,
          items: respBody.items,
          marker: respBody.marker,
          hasMore: respBody.marker !== '',
        });
      } else {
        console.error(`七牛云列表查询失败: HTTP ${respInfo.statusCode}`);
        reject(new Error(`List files failed with status code: ${respInfo.statusCode}`));
      }
    });
  });
}

/**
 * 生成图片处理URL
 * @param {string} key - 图片文件路径
 * @param {Object} options - 处理选项
 * @returns {string} 处理后的图片URL
 */
export function getImageUrl(key, options = {}) {
  const baseUrl = `${cdnDomain}/${key}`;
  const params = [];

  // 缩放
  if (options.width || options.height) {
    const mode = options.mode || 1; // 1=限定宽高缩放, 2=限定宽高裁剪
    let imageView = `imageView2/${mode}`;
    if (options.width) imageView += `/w/${options.width}`;
    if (options.height) imageView += `/h/${options.height}`;
    params.push(imageView);
  }

  // 质量
  if (options.quality) {
    params.push(`imageMogr2/quality/${options.quality}`);
  }

  // 格式转换
  if (options.format) {
    params.push(`imageMogr2/format/${options.format}`);
  }

  // 水印
  if (options.watermark) {
    params.push(`watermark/2/text/${Buffer.from(options.watermark).toString('base64')}`);
  }

  return params.length > 0 ? `${baseUrl}?${params.join('|')}` : baseUrl;
}

// 导出所有方法
export default {
  getUploadToken,
  uploadFile,
  uploadBuffer,
  uploadStream,
  deleteFile,
  deleteFiles,
  getFileInfo,
  getPrivateUrl,
  copyFile,
  moveFile,
  listFiles,
  getImageUrl,
};

