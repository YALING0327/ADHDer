import { NextRequest, NextResponse } from "next/server";
import { prisma } from "@adhder/db/src/client";
import { getSession } from "@/app/lib/auth";

export async function GET() {
  const session = getSession();
  if (!session) return NextResponse.json({ error: "unauthorized" }, { status: 401 });
  const items = await prisma.focusSession.findMany({ where: { uid: session.uid }, orderBy: { start: "desc" } });
  return NextResponse.json({ items });
}

export async function POST(req: NextRequest) {
  const session = getSession();
  if (!session) return NextResponse.json({ error: "unauthorized" }, { status: 401 });
  const { mode, start, end, interrupts, notes } = await req.json();
  const item = await prisma.focusSession.create({
    data: { uid: session.uid, mode, start: start ? new Date(start) : undefined, end: end ? new Date(end) : undefined, interrupts: interrupts ?? 0, notes },
  });
  return NextResponse.json({ item });
}


