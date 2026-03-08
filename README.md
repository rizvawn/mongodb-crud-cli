# MongoDB: CRUD-operationer med Bash och mongosh

Detta projekt är en övning med MongoDB där fokus ligger på de mest grundläggande
koncepten.

### Varför Bash och CLI?
Kommandoraden valdes framför grafiska verktyg som MongoDB Atlas och Compass för att arbeta direkt mot databasen utan mellanlager. Det ger en tydligare förståelse för hur MongoDB faktiskt fungerar. Valet föll sig också naturligt efter en period av aktivt arbete med Linux och terminalmiljön, där CLI redan var den primära arbetsmiljön.

Detta tillvägagångssätt ger flera fördelar:

- **Automatisering**: Varje steg i processen är repeterbart och dokumenterat i kod.
- **Renhet**: Genom att använda MongoDB Shell (`mongosh`) direkt ser man exakt hur databasen svarar utan abstraktionslager.
- **Miljöhantering**: Genom att köra MongoDB i Docker säkerställs en isolerad och ren utvecklingsmiljö som är lätt att sätta upp och ta bort.

### Projektets struktur
Övningen använder databasen `devops25_nosql` med kollektioner `orders`, `customers` och `products`. Arbetet är uppdelat i tio numrerade Bash-skript som körs stegvis. De fem första täcker CRUD-cykeln mot `orders`. De efterföljande fem hanterar kunddata, produktreferenser, uppslagningar mellan kollektioner, jämförelse av dokumentmodeller och schemavalidering.

Innan skripten körs behöver MongoDB köra i Docker. Containern skapas en gång med:
`docker run -d --name mongodb -p 27017:27017 mongo:latest`
Vid efterföljande tillfällen räcker det med:
`docker start mongodb`
Därefter är `mongosh` tillgängligt mot `localhost:27017`.

### Steg 1: Skapa kollektionen `orders` (Create)
Skriptet `01_create_orders.sh` skapar kollektionen `orders` i databasen `devops25_nosql` och fyller den med femton orderdokument från en fiktiv svensk souvenirbutik. Fem kunder används genomgående i datan, identifierade som `visitor-001` till `visitor-005`. Produktsortimentet består av arton distinkta souvenirer, från dalahästar och vikingahjälmar till samiska armband och lapplandshalsdukar. Fältet `totalAmount` är förutsummat utifrån kvantitet och pris per produkt. Statusalternativen som förekommer är `delivered`, `shipped`, `pending` och `cancelled`. Anslutningen till MongoDB sker via `docker exec` mot en körande container. Produktdata är avsiktligt inbäddad i ordrarna för att senare kontrasteras mot ett referensbaserat alternativ i analysen av dokumentmodeller.

### Steg 2: Hämta dokument (Read)
Skriptet `02_read_orders.sh` visar fyra olika sätt att läsa data från kollektionen. Först hämtas samtliga ordrar kopplade till en enskild kund med ett exakt matchningsfilter. Därefter används en jämförelseoperator för att hitta ordrar vars `totalAmount` överstiger 1000 kronor. Sedan sorteras hela kollektionen på `totalAmount` i fallande ordning för att ge en överblick av köpen efter värde. Slutligen kombineras sortering och begränsning för att returnera de fem dyraste ordrarna. Projektionsparametern används för att hålla utdata läsbar.

### Steg 3: Uppdatera dokument (Update)
Skriptet `03_update_orders.sh` visar tre distinkta uppdateringsoperationer. Med `$set` ändras statusen på visitor-002:s order från `pending` till `processing`. Med `$push` läggs en ny produkt till i `items`-arrayen på visitor-003:s order utan att skriva om hela arrayen. Med `$inc` ökas `totalAmount` med exakt det belopp som den nya produkten tillförde. Varje operation omges av ett `findOne`-anrop före och efter för att göra förändringen synlig i utdata. Vid upprepade körningar bör skriptet föregås av `01_create_orders.sh` för att återställa datan, alternativt kan dokumentets `_id` användas som filter för att garantera ett exakt träff.

### Steg 4: Radera dokument (Delete)
Skriptet `04_delete_orders.sh` demonstrerar två raderingsoperationer. Med `deleteOne` tas den avbrutna ordern för `visitor-005` bort, ett mönster som speglar hur avbrutna transaktioner kan rensas från en aktiv kollektion. Med `deleteMany` raderas samtliga ordrar vars `totalAmount` understiger 115 kronor, vilket visar hur ett villkorsbaserat filter kan påverka flera dokument i ett enda anrop. Antalet kvarvarande dokument skrivs ut efter varje operation och kollektionen ska efter detta steg innehålla exakt tio dokument.

### Steg 5: Verifiera slutresultatet (Verify)
Skriptet `05_verify_collection.sh` sammanfattar övningen genom att bekräfta att databasen befinner sig i förväntat slutläge. Antalet dokument i kollektionen kontrolleras, de uppdaterade dokumenten visas med sina nya värden och de raderade dokumenten bekräftas vara borta. Filtret `totalAmount > 1000` körs en sista gång för att visa att det fungerar mot den slutliga datan. Skriptet fungerar som ett kvitto på att alla CRUD-operationer har utförts korrekt och i rätt ordning.

### Steg 6: Skapa kollektionen `customers` (Create)
Skriptet `06_create_customers.sh` skapar kollektionen `customers` och fyller den med fem dokument, ett per kund som förekommer i `orders`-kollektionen. Varje dokument innehåller fälten `customerId`, `name` och `email`. Fältet `customerId` är den gemensamma nyckeln som knyter samman de två kollektionerna och möjliggör uppslagningar mellan dem.

### Steg 7: Skapa kollektionen `products` (Create)
Skriptet `07_create_products.sh` skapar kollektionen `products` med ett enda dokument. Produkten `souvenir-01` finns redan inbäddad i flera ordrar men läggs här även in som ett fristående dokument för att möjliggöra en referensbaserad uppslagning i nästa steg. Kollektionen illustrerar hur en produkt i ett referensbaserat schema skulle lagras separat istället för att dupliceras inuti varje order. Noterbart är att fältet `quantity` inte ingår i produktdokumentet då det beskriver orderraden, inte produkten i sig.

### Steg 8: Referensbaserad uppslagning (Reference Lookup)
Skriptet `08_reference_lookup.sh` visar hur två kollektioner knyts samman via ett gemensamt fält. En order hämtas ur `orders`, kollektionen och dess `customerId` används sedan för att slå upp motsvarande dokument i `customers`. Resultatet kombineras och presenteras som ett sammansatt objekt. Detta är det manuella alternativet till en JOIN i relationsdatabaser och tydliggör både styrkan och begränsningen med referensbaserad modellering i MongoDB där datan hålls normaliserad men kräver flera anrop för att sättas samman.

### Steg 9: Inbäddad kontra referensbaserad modellering
Skriptet `09_embedded_vs_referenced.sh` kontrasterar de två grundläggande dokumentmodellerna i MongoDB. Två testordrar infogas i kollektionen `orders`: en med kunddata inbäddad direkt i dokumentet och en där `items`-arrayen enbart innehåller ett `productId` som pekar mot `products`-kollektionen.

**Fördelar med referens:**
Datan lagras på ett ställe. Om en kunds e-postadress ändras uppdateras den i `customers` och alla ordrar speglar automatiskt den nya informationen. Ingen duplicering, ingen risk för inkonsekvens.

**Fördelar med inbäddning:**
All information hämtas i ett enda anrop utan behov av en separat uppslagning. Lämpligt när datan är statisk och tillhör dokumentet kontextuellt, som orderrader vars pris och namn ska spegla exakt vad kunden köpte vid köptillfället, oavsett framtida prisändringar.

**När man prioriterar referens:**
När datan delas mellan många dokument, uppdateras ofta eller är stor. Kundprofiler, produktkataloger och kategorier är typiska kandidater.

**När man prioriterar inbäddning:**
När datan är unik per dokument, sällan ändras och alltid läses tillsammans med sitt föräldradokument. Orderrader och adresser vid köptillfället är klassiska exempel.

### Steg 10: Schemavalidering (Schema Validation)
Skriptet `10_schema_validation.sh` tillämpar en JSON Schema-validator på kollektionen `orders` med `collMod`. Valideringen kräver att alla fem fält är närvarande, att `totalAmount` är ett icke-negativt tal och att `status` är ett av de fördefinierade värdena. Valideringsnivån är satt till `strict` och åtgärden till `error`, vilket innebär att MongoDB aktivt nekar icke-konforma dokument.

För att testa valideringen görs ett försök att infoga ett dokument som saknar `createdAt` och `items`, har ett negativt `totalAmount` och en ogiltig `status`. MongoDB kastar ett fel `DocumentValidationFailure` och dokumentet skrivs aldrig till kollektionen. Dokumentantalet förblir oförändrat, vilket bekräftas i det sista steget. Schemavalidering är ett effektivt sätt att upprätthålla dataintegritet direkt i databasen, oberoende av applikationslagret.

### Körning av hela övningen i ett steg
Skriptet `run_all.sh` kör samtliga tio skript i rätt ordning och skriver utdata till filen `mongodb_report.txt` via `tee`, vilket innebär att resultatet visas i terminalen och sparas till fil samtidigt. Antalet steg beräknas dynamiskt utifrån skriptlistan, vilket gör det enkelt att utöka övningen utan att uppdatera skriptet manuellt. Varje steg avgränsas med en tydlig rubrik som anger vilket skript som körs och vad det gör. Eftersom skriptet börjar med att återskapa alla kollektioner är hela övningen fullt repeterbar med ett enda kommando.