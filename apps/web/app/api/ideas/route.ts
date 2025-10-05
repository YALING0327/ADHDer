import { NextRequest, NextResponse } from "next/server";
import { prisma } from "@adhder/db/src/client";
import { getSession } from "@/app/lib/auth";

export async function GET() {
  const session = getSession();
  if (!session) return NextResponse.json({ error: "unauthorized" }, { status: 401 });
  const items = await prisma.idea.findMany({ where: { uid: session.uid }, orderBy: { createdAt: "desc" } });
  return NextResponse.json({ items });
}

export async function POST(req: NextRequest) {
  const session = getSession();
  if (!session) return NextResponse.json({ error: "unauthorized" }, { status: 401 });
  const { text, audioRef, context, status } = await req.json();
  const item = await prisma.idea.create({ data: { uid: session.uid, text, audioRef, context, status } });
  return NextResponse.json({ item });
}


