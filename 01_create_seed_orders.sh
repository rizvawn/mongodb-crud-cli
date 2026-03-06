#!/bin/bash
# Lägger in testordrar i devops25_nosql.orders.
# Kör med: bash 01_create_orders.sh
# Kräver: mongosh och att MongoDB körs på localhost:27017

docker exec -i mongodb mongosh "mongodb://localhost:27017/devops25_nosql" --quiet <<EOF

db.orders.drop();

db.orders.insertMany([
    {
        customerId: "visitor-003",
        createdAt: new Date("2025-02-11"),
        items: [
            { productId: "souvenir-01", name: "Stockholm Mug", quantity: 2, price: 120 },
            { productId: "souvenir-02", name: "Swedish Flag Keychain", quantity: 1, price: 50 }
        ],
        totalAmount: 290,
        status: "shipped"
    },
    {
        customerId: "visitor-001",
        createdAt: new Date("2025-03-05"),
        items: [
            { productId: "souvenir-03", name: "Viking Helmet", quantity: 1, price: 350 }
        ],
        totalAmount: 350,
        status: "delivered"
    },
    {
        customerId: "visitor-005",
        createdAt: new Date("2025-03-10"),
        items: [
            { productId: "souvenir-04", name: "Dala Horse Figurine", quantity: 1, price: 200 },
            { productId: "souvenir-05", name: "Postcard Set", quantity: 3, price: 30 }
        ],
        totalAmount: 290,
        status: "pending"
    },
    {
        customerId: "visitor-002",
        createdAt: new Date("2025-03-12"),
        items: [
            { productId: "souvenir-06", name: "Lapland Magnet", quantity: 4, price: 25 }
        ],
        totalAmount: 100,
        status: "shipped"
    },
    {
        customerId: "visitor-004",
        createdAt: new Date("2025-03-15"),
        items: [
            { productId: "souvenir-07", name: "Moose Plush Toy", quantity: 1, price: 180 }
        ],
        totalAmount: 180,
        status: "delivered"
    },
    {
        customerId: "visitor-002",
        createdAt: new Date("2025-03-18"),
        items: [
            { productId: "souvenir-08", name: "Sweden T-shirt", quantity: 2, price: 220 }
        ],
        totalAmount: 440,
        status: "pending"
    },
    {
        customerId: "visitor-005",
        createdAt: new Date("2025-03-20"),
        items: [
            { productId: "souvenir-09", name: "Fika Coffee Beans", quantity: 1, price: 150 },
            { productId: "souvenir-10", name: "Cinnamon Bun Candle", quantity: 2, price: 60 }
        ],
        totalAmount: 270,
        status: "shipped"
    },
    {
        customerId: "visitor-001",
        createdAt: new Date("2025-03-22"),
        items: [
            { productId: "souvenir-11", name: "Aurora Borealis Poster", quantity: 1, price: 90 }
        ],
        totalAmount: 90,
        status: "delivered"
    },
    {
        customerId: "visitor-003",
        createdAt: new Date("2025-03-25"),
        items: [
            { productId: "souvenir-12", name: "Swedish Recipe Book", quantity: 1, price: 160 }
        ],
        totalAmount: 160,
        status: "pending"
    },
    {
        customerId: "visitor-004",
        createdAt: new Date("2025-03-28"),
        items: [
            { productId: "souvenir-13", name: "Gothenburg Tote Bag", quantity: 1, price: 110 }
        ],
        totalAmount: 110,
        status: "shipped"
    },
    {
        customerId: "visitor-002",
        createdAt: new Date("2025-03-30"),
        items: [
            { productId: "souvenir-14", name: "Midsummer Flower Crown", quantity: 1, price: 75 }
        ],
        totalAmount: 75,
        status: "delivered"
    },
    {
        customerId: "visitor-005",
        createdAt: new Date("2025-04-01"),
        items: [
            { productId: "souvenir-15", name: "Sami Bracelet", quantity: 1, price: 250 }
        ],
        totalAmount: 250,
        status: "cancelled"
    },
    {
        customerId: "visitor-003",
        createdAt: new Date("2025-04-03"),
        items: [
            { productId: "souvenir-16", name: "Swedish Lapland Scarf", quantity: 1, price: 200 }
        ],
        totalAmount: 200,
        status: "shipped"
    },
    {
        customerId: "visitor-001",
        createdAt: new Date("2025-04-05"),
        items: [
            { productId: "souvenir-17", name: "Lucia Candle Holder", quantity: 2, price: 80 }
        ],
        totalAmount: 160,
        status: "delivered"
    },
    {
        customerId: "visitor-004",
        createdAt: new Date("2025-04-07"),
        items: [
            { productId: "souvenir-18", name: "Swedish Moose T-shirt", quantity: 1, price: 220 }
        ],
        totalAmount: 220,
        status: "pending"
    }
]);

print("Documents in collection: " + db.orders.countDocuments());
EOF