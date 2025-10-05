import { NextRequest, NextResponse } from "next/server";
import { prisma } from "@adhder/db/src/client";
import { getSession } from "@/app/lib/auth";

export async function GET() {
  const session = getSession();
  if (!session) return NextResponse.json({ error: "unauthorized" }, { status: 401 });
  const items = await prisma.sleepSession.findMany({ where: { uid: session.uid }, orderBy: { id: "desc" } });
  return NextResponse.json({ items });
}

export async function POST(req: NextRequest) {
  const session = getSession();
  if (!session) return NextResponse.json({ error: "unauthorized" }, { status: 401 });
  const { soundscape, duration, endedBy } = await req.json();
  const item = await prisma.sleepSession.create({ data: { uid: session.uid, soundscape, duration, endedBy } });
  return NextResponse.json({ item });
}


