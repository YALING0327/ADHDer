import { cookies } from "next/headers";
import jwt from "jsonwebtoken";

const JWT_SECRET = process.env.JWT_SECRET || "dev-secret";

export interface Session {
  uid: string;
  email: string;
}

export function getSession(): Session | null {
  const cookieStore = cookies();
  const token = cookieStore.get("auth")?.value;
  if (!token) return null;
  try {
    const payload = jwt.verify(token, JWT_SECRET) as Session;
    return payload;
  } catch {
    return null;
  }
}


