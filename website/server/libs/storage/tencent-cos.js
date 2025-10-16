/**
 * 腾讯云COS对象存储服务
 * 用于图片、文件的上传和管理
 */

import COS from 'cos-nodejs-sdk-v5';
import nconf from 'nconf';

// 腾讯云配置
const SecretId = nconf.get('TENCENT_CLOUD_SECRET_ID');
const SecretKey = nconf.get('TENCENT_CLOUD_SECRET_KEY');
const Region = nconf.get('TENCENT_COS_REGION') || 'ap-guangzhou';
const Bucket = nconf.get('TENCENT_COS_BUCKET');
const CdnDomain = nconf.get('TENCENT_COS_CDN_DOMAIN');

// 初始化COS实例
const cos = new COS({
  SecretId,
  SecretKey,
});

/**
 * 上传文件
 * @param {string} localFile - 本地文件路径
 * @param {string} key - 文件保存路径（如：avatars/user123.jpg）
 * @returns {Promise<Object>} 上传结果
 */
export async function uploadFile(localFile, key) {
  return new Promise((resolve, reject) => {
    cos.putObject({
      Bucket,
      Region,
      Key: key,
      StorageClass: 'STANDARD',
      Body: require('fs').createReadStream(localFile),
      onProgress: (progressData) => {
        console.log(`上传进度: ${JSON.stringify(progressData)}`);
      },
    }, (err, data) => {
      if (err) {
        console.error('腾讯云COS上传失败:', err);
        reject(err);
      } else {
        console.log(`✅ 文件上传成功: ${key}`);
        const url = CdnDomain ? `${CdnDomain}/${key}` : `https://${Bucket}.cos.${Region}.myqcloud.com/${key}`;
        resolve({
          success: true,
          url,
          key,
          location: data.Location,
          etag: data.ETag,
        });
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
    cos.putObject({
      Bucket,
      Region,
      Key: key,
      StorageClass: 'STANDARD',
      Body: buffer,
    }, (err, data) => {
      if (err) {
        console.error('腾讯云COS上传失败:', err);
        reject(err);
      } else {
        console.log(`✅ Buffer上传成功: ${key}`);
        const url = CdnDomain ? `${CdnDomain}/${key}` : `https://${Bucket}.cos.${Region}.myqcloud.com/${key}`;
        resolve({
          success: true,
          url,
          key,
          etag: data.ETag,
        });
      }
    });
  });
}

/**
 * 上传Stream数据
 * @param {Stream} stream - 可读流
 * @param {string} key - 文件保存路径
 * @returns {Promise<Object>} 上传结果
 */
export async function uploadStream(stream, key) {
  return new Promise((resolve, reject) => {
    cos.putObject({
      Bucket,
      Region,
      Key: key,
      StorageClass: 'STANDARD',
      Body: stream,
    }, (err, data) => {
      if (err) {
        console.error('腾讯云COS上传失败:', err);
        reject(err);
      } else {
        console.log(`✅ Stream上传成功: ${key}`);
        const url = CdnDomain ? `${CdnDomain}/${key}` : `https://${Bucket}.cos.${Region}.myqcloud.com/${key}`;
        resolve({
          success: true,
          url,
          key,
          etag: data.ETag,
        });
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
    cos.deleteObject({
      Bucket,
      Region,
      Key: key,
    }, (err, data) => {
      if (err) {
        console.error('腾讯云COS删除失败:', err);
        reject(err);
      } else {
        console.log(`✅ 文件删除成功: ${key}`);
        resolve({ success: true, data });
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
    cos.deleteMultipleObject({
      Bucket,
      Region,
      Objects: keys.map(key => ({ Key: key })),
    }, (err, data) => {
      if (err) {
        console.error('腾讯云COS批量删除失败:', err);
        reject(err);
      } else {
        console.log(`✅ 批量删除成功: ${keys.length}个文件`);
        resolve({
          success: true,
          deleted: data.Deleted,
          errors: data.Error,
        });
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
    cos.headObject({
      Bucket,
      Region,
      Key: key,
    }, (err, data) => {
      if (err) {
        console.error('获取文件信息失败:', err);
        reject(err);
      } else {
        resolve({
          success: true,
          info: {
            size: data.headers['content-length'],
            contentType: data.headers['content-type'],
            etag: data.headers.etag,
            lastModified: data.headers['last-modified'],
          },
        });
      }
    });
  });
}

/**
 * 复制文件
 * @param {string} srcKey - 源文件路径
 * @param {string} destKey - 目标文件路径
 * @returns {Promise<Object>} 复制结果
 */
export async function copyFile(srcKey, destKey) {
  return new Promise((resolve, reject) => {
    cos.putObjectCopy({
      Bucket,
      Region,
      Key: destKey,
      CopySource: `${Bucket}.cos.${Region}.myqcloud.com/${srcKey}`,
    }, (err, data) => {
      if (err) {
        console.error('腾讯云COS复制失败:', err);
        reject(err);
      } else {
        console.log(`✅ 文件复制成功: ${srcKey} -> ${destKey}`);
        resolve({ success: true, data });
      }
    });
  });
}

/**
 * 列出文件
 * @param {string} prefix - 文件前缀
 * @param {string} marker - 分页标记
 * @param {number} maxKeys - 返回数量限制，默认1000
 * @returns {Promise<Object>} 文件列表
 */
export async function listFiles(prefix = '', marker = '', maxKeys = 1000) {
  return new Promise((resolve, reject) => {
    cos.getBucket({
      Bucket,
      Region,
      Prefix: prefix,
      Marker: marker,
      MaxKeys: maxKeys,
    }, (err, data) => {
      if (err) {
        console.error('腾讯云COS列表查询失败:', err);
        reject(err);
      } else {
        resolve({
          success: true,
          files: data.Contents,
          nextMarker: data.NextMarker,
          isTruncated: data.IsTruncated === 'true',
        });
      }
    });
  });
}

/**
 * 生成预签名URL（用于临时访问私有文件）
 * @param {string} key - 文件路径
 * @param {number} expires - 有效期（秒），默认1小时
 * @returns {string} 预签名URL
 */
export function getSignedUrl(key, expires = 3600) {
  return cos.getObjectUrl({
    Bucket,
    Region,
    Key: key,
    Sign: true,
    Expires: expires,
  });
}

/**
 * 生成图片处理URL
 * @param {string} key - 图片文件路径
 * @param {Object} options - 处理选项
 * @returns {string} 处理后的图片URL
 */
export function getImageUrl(key, options = {}) {
  const baseUrl = CdnDomain 
    ? `${CdnDomain}/${key}` 
    : `https://${Bucket}.cos.${Region}.myqcloud.com/${key}`;
  
  const params = [];

  // 缩放
  if (options.width || options.height) {
    let thumbnail = 'imageMogr2/thumbnail/';
    if (options.width && options.height) {
      thumbnail += `${options.width}x${options.height}`;
    } else if (options.width) {
      thumbnail += `${options.width}x`;
    } else {
      thumbnail += `x${options.height}`;
    }
    params.push(thumbnail);
  }

  // 质量
  if (options.quality) {
    params.push(`imageMogr2/quality/${options.quality}`);
  }

  // 格式转换
  if (options.format) {
    params.push(`imageMogr2/format/${options.format}`);
  }

  // 裁剪
  if (options.crop) {
    const { width, height, x = 0, y = 0 } = options.crop;
    params.push(`imageMogr2/crop/${width}x${height}x${x}x${y}`);
  }

  // 旋转
  if (options.rotate) {
    params.push(`imageMogr2/rotate/${options.rotate}`);
  }

  // 水印
  if (options.watermark) {
    const watermarkText = Buffer.from(options.watermark).toString('base64');
    params.push(`watermark/2/text/${watermarkText}`);
  }

  return params.length > 0 ? `${baseUrl}?${params.join('|')}` : baseUrl;
}

/**
 * 上传文件（支持自动分片）
 * @param {string} localFile - 本地文件路径
 * @param {string} key - 文件保存路径
 * @param {Function} onProgress - 进度回调
 * @returns {Promise<Object>} 上传结果
 */
export async function uploadLargeFile(localFile, key, onProgress) {
  return new Promise((resolve, reject) => {
    cos.sliceUploadFile({
      Bucket,
      Region,
      Key: key,
      FilePath: localFile,
      onTaskReady: (taskId) => {
        console.log(`任务ID: ${taskId}`);
      },
      onProgress: (progressData) => {
        if (onProgress) onProgress(progressData);
        console.log(`上传进度: ${Math.round(progressData.percent * 100)}%`);
      },
    }, (err, data) => {
      if (err) {
        console.error('腾讯云COS分片上传失败:', err);
        reject(err);
      } else {
        console.log(`✅ 大文件上传成功: ${key}`);
        const url = CdnDomain ? `${CdnDomain}/${key}` : data.Location;
        resolve({
          success: true,
          url,
          key,
          location: data.Location,
          etag: data.ETag,
        });
      }
    });
  });
}

// 导出所有方法
export default {
  uploadFile,
  uploadBuffer,
  uploadStream,
  deleteFile,
  deleteFiles,
  getFileInfo,
  copyFile,
  listFiles,
  getSignedUrl,
  getImageUrl,
  uploadLargeFile,
};

