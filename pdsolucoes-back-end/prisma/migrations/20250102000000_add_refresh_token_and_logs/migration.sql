-- AlterTable
ALTER TABLE "users" ADD COLUMN "refreshToken" TEXT;

-- CreateTable
CREATE TABLE "logs" (
    "id" TEXT NOT NULL,
    "level" TEXT NOT NULL,
    "errorCode" TEXT,
    "message" TEXT NOT NULL,
    "path" TEXT,
    "layer" TEXT,
    "httpMethod" TEXT,
    "httpUrl" TEXT,
    "httpStatusCode" INTEGER,
    "responseTime" INTEGER,
    "userId" TEXT,
    "userEmail" TEXT,
    "userName" TEXT,
    "ip" TEXT,
    "userAgent" TEXT,
    "referer" TEXT,
    "origin" TEXT,
    "acceptLanguage" TEXT,
    "requestHeaders" JSONB,
    "requestBody" JSONB,
    "requestParams" JSONB,
    "requestQuery" JSONB,
    "responseBody" JSONB,
    "stack" TEXT,
    "errorName" TEXT,
    "errorMessage" TEXT,
    "isOperational" BOOLEAN NOT NULL DEFAULT true,
    "environment" TEXT,
    "serverInstance" TEXT,
    "nodeVersion" TEXT,
    "appVersion" TEXT,
    "additionalData" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "logs_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "logs_level_idx" ON "logs"("level");

-- CreateIndex
CREATE INDEX "logs_errorCode_idx" ON "logs"("errorCode");

-- CreateIndex
CREATE INDEX "logs_userId_idx" ON "logs"("userId");

-- CreateIndex
CREATE INDEX "logs_createdAt_idx" ON "logs"("createdAt");

-- CreateIndex
CREATE INDEX "logs_httpStatusCode_idx" ON "logs"("httpStatusCode");

-- CreateIndex
CREATE INDEX "logs_httpMethod_idx" ON "logs"("httpMethod");



