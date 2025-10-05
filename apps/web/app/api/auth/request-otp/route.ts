import { NextRequest, NextResponse } from "next/server";
import { prisma } from "@adhder/db/src/client";
import { Resend } from "resend";

const resend = new Resend(process.env.RESEND_API_KEY);

export async function POST(req: NextRequest) {
  const { email } = await req.json();
  if (!email || typeof email !== "string") {
    return NextResponse.json({ error: "invalid_email" }, { status: 400 });
  }

  const code = Math.floor(100000 + Math.random() * 900000).toString();
  const expiresAt = new Date(Date.now() + 10 * 60 * 1000);
  await prisma.emailOtp.create({ data: { email: email.toLowerCase(), code, expiresAt } });

  if (!process.env.RESEND_API_KEY) {
    return NextResponse.json({ ok: true, code }, { status: 200 });
  }

  await resend.emails.send({
    from: "ADHDer <login@adhder.app>",
    to: email,
    subject: "Your ADHDer code",
    text: `Your login code is ${code}. It expires in 10 minutes.`
  });

  return NextResponse.json({ ok: true }, { status: 200 });
}


