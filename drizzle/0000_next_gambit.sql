DO $$ BEGIN
 CREATE TYPE "skateshop_category" AS ENUM('skateboards', 'clothing', 'shoes', 'accessories');
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "skateshop_addresses" (
	"id" varchar(30) PRIMARY KEY NOT NULL,
	"line1" varchar(256),
	"line2" varchar(256),
	"city" varchar(256),
	"state" varchar(256),
	"postal_code" varchar(256),
	"country" varchar(256),
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT current_timestamp
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "skateshop_carts" (
	"id" varchar(30) PRIMARY KEY NOT NULL,
	"payment_intent_id" varchar(256),
	"client_secret" varchar(256),
	"items" json DEFAULT 'null'::json,
	"closed" boolean DEFAULT false NOT NULL,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT current_timestamp
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "skateshop_notifications" (
	"id" varchar(30) PRIMARY KEY NOT NULL,
	"user_id" varchar(36),
	"email" varchar(256) NOT NULL,
	"token" varchar(256) NOT NULL,
	"referred_by" varchar(256),
	"newsletter" boolean DEFAULT false NOT NULL,
	"marketing" boolean DEFAULT false NOT NULL,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT current_timestamp,
	CONSTRAINT "skateshop_notifications_user_id_unique" UNIQUE("user_id"),
	CONSTRAINT "skateshop_notifications_email_unique" UNIQUE("email"),
	CONSTRAINT "skateshop_notifications_token_unique" UNIQUE("token")
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "skateshop_orders" (
	"id" varchar(30) PRIMARY KEY NOT NULL,
	"store_id" varchar(30) NOT NULL,
	"items" json DEFAULT 'null'::json,
	"quantity" integer,
	"amount" numeric(10, 2) DEFAULT '0' NOT NULL,
	"stripe_payment_intent_id" varchar(256) NOT NULL,
	"stripe_payment_intent_status" varchar(256) NOT NULL,
	"name" varchar(256) NOT NULL,
	"email" varchar(256) NOT NULL,
	"address_id" integer,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT current_timestamp
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "skateshop_payments" (
	"id" varchar(30) PRIMARY KEY NOT NULL,
	"store_id" varchar(30) NOT NULL,
	"stripe_account_id" varchar(256) NOT NULL,
	"stripe_account_created_at" integer,
	"stripe_account_expires_at" integer,
	"details_submitted" boolean DEFAULT false NOT NULL,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT current_timestamp
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "skateshop_products" (
	"id" varchar(30) PRIMARY KEY NOT NULL,
	"name" varchar(256) NOT NULL,
	"description" text,
	"images" json DEFAULT 'null'::json,
	"category" "skateshop_category" DEFAULT 'skateboards' NOT NULL,
	"subcategory" varchar(256),
	"price" numeric(10, 2) DEFAULT '0' NOT NULL,
	"inventory" integer DEFAULT 0 NOT NULL,
	"rating" integer DEFAULT 0 NOT NULL,
	"tags" json DEFAULT 'null'::json,
	"store_id" varchar(30) NOT NULL,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT current_timestamp
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "skateshop_stores" (
	"id" varchar(30) PRIMARY KEY NOT NULL,
	"user_id" varchar(36),
	"name" varchar NOT NULL,
	"description" text,
	"slug" text,
	"active" boolean DEFAULT false NOT NULL,
	"stripe_account_id" varchar,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT current_timestamp,
	CONSTRAINT "skateshop_stores_user_id_unique" UNIQUE("user_id"),
	CONSTRAINT "skateshop_stores_slug_unique" UNIQUE("slug")
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "skateshop_subscriptions" (
	"id" varchar(30) PRIMARY KEY NOT NULL,
	"user_id" varchar(36),
	"stripe_subscription_id" varchar(256),
	"stripe_price_id" varchar(256),
	"stripe_customer_id" varchar(256),
	"stripe_current_period_end" timestamp,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT current_timestamp,
	CONSTRAINT "skateshop_subscriptions_user_id_unique" UNIQUE("user_id")
);
--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "store_id_idx" ON "skateshop_products" ("store_id");