import { NextResponse } from "next/server";

export default (request) => NextResponse.rewrite(new URL('/foo', request.url));
