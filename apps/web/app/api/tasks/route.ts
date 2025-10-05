import { NextRequest, NextResponse } from "next/server";
import { prisma } from "@adhder/db/src/client";
import { getSession } from "@/app/lib/auth";

export async function GET() {
  const session = getSession();
  if (!session) return NextResponse.json({ error: "unauthorized" }, { status: 401 });
  const tasks = await prisma.task.findMany({ where: { uid: session.uid }, orderBy: { createdAt: "desc" } });
  return NextResponse.json({ tasks });
}

export async function POST(req: NextRequest) {
  const session = getSession();
  if (!session) return NextResponse.json({ error: "unauthorized" }, { status: 401 });
  const { title, type, due } = await req.json();
  if (!title || (type !== "free" && type !== "ddl")) {
    return NextResponse.json({ error: "invalid" }, { status: 400 });
  }
  const task = await prisma.task.create({
    data: { uid: session.uid, title, type, due: due ? new Date(due) : undefined },
  });
  return NextResponse.json({ task });
}


