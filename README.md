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
Övningen använder databasen `devops25_nosql` med kollektionen `orders`. Arbetet är uppdelat i fem numrerade Bash-skript som körs stegvis, ett per fas av CRUD-cykeln: skapa, läsa, uppdatera och radera dokument.

Innan skripten körs behöver MongoDB köra i Docker. Containern skapas en gång med:
`docker run -d --name mongodb -p 27017:27017 mongo:latest`
Vid efterföljande tillfällen räcker det med:
`docker start mongodb`
Därefter är `mongosh` tillgängligt mot `localhost:27017`.

### Steg 1: Skapa kollektionen `orders` och dess dokument (Create)
Skriptet `01_create_orders.sh` skapar kollektionen `orders` i databasen `devops25_nosql` och fyller den med femton orderdokument från en fiktiv svensk souvenirbutik. Fem kunder används genomgående i datan, identifierade som `visitor-001` till `visitor-005`. Produktsortimentet består av arton distinkta souvenirer, från dalahästar och vikingahjälmar till samiska armband och lapplandshalsdukar. Fältet `totalAmount` är förutsummat utifrån kvantitet och pris per produkt. Statusalternativen som förekommer är `delivered`, `shipped`, `pending` och `cancelled`. Anslutningen till MongoDB sker via `docker exec` mot en körande container.

### Steg 2: Hämta dokument (Read)
Skriptet `02_read_orders.sh` visar fyra olika sätt att läsa data från kollektionen. Först hämtas samtliga ordrar kopplade till en enskild kund med ett exakt matchningsfilter. Därefter används en jämförelseoperator för att hitta ordrar vars `totalAmount` överstiger 1000 kronor. Sedan sorteras hela kollektionen på `totalAmount` i fallande ordning för att ge en överblick av köpen efter värde. Slutligen kombineras sortering och begränsning för att returnera de fem dyraste ordrarna. Projektionsparametern används för att hålla utdata läsbar.

### Steg 3: Uppdatera dokument (Update)
Skriptet `03_update_orders.sh` visar tre distinkta uppdateringsoperationer. Med `$set` ändras statusen på visitor-002:s order från `pending` till `processing`. Med `$push` läggs en ny produkt till i `items`-arrayen på visitor-003:s order utan att skriva om hela arrayen. Med `$inc` ökas `totalAmount` med exakt det belopp som den nya produkten tillförde. Varje operation omges av ett `findOne`-anrop före och efter för att göra förändringen synlig i utdata. Vid upprepade körningar bör skriptet föregås av `01_create_orders.sh` för att återställa datan, alternativt kan dokumentets `_id` användas som filter för att garantera ett exakt träff.

### Steg 4: Radera dokument (Delete)
Skriptet `04_delete_orders.sh` demonstrerar två raderingsoperationer. Med `deleteOne` tas den avbrutna ordern för `visitor-005` bort, ett mönster som speglar hur avbrutna transaktioner kan rensas från en aktiv kollektion. Med `deleteMany` raderas samtliga ordrar vars `totalAmount` understiger 115 kronor, vilket visar hur ett villkorsbaserat filter kan påverka flera dokument i ett enda anrop. Antalet kvarvarande dokument skrivs ut efter varje operation och kollektionen ska efter detta steg innehålla exakt tio dokument.

### Steg 5: Verifiera slutresultatet (Verify)
Skriptet `05_verify_collection.sh` sammanfattar övningen genom att bekräfta att databasen befinner sig i förväntat slutläge. Antalet dokument i kollektionen kontrolleras, de uppdaterade dokumenten visas med sina nya värden och de raderade dokumenten bekräftas vara borta. Filtret `totalAmount > 1000` körs en sista gång för att visa att det fungerar mot den slutliga datan. Skriptet fungerar som ett kvitto på att alla CRUD-operationer har utförts korrekt och i rätt ordning.

### Steg 6: Skapa kollektion `customers` och dess dokument (Create)
Skriptet `06_create_customers.sh` skapar kollektionen `customers` och fyller den med fem dokument, ett per kund som förekommer i `orders`-kollektionen. Varje dokument innehåller fälten `customerId`, `name` och `email`. Fältet `customerId` är den gemensamma nyckeln som knyter samman de två kollektionerna och möjliggör uppslagningar mellan dem.

### Körning av hela övningen i ett steg
Skriptet `run_all.sh` kör samtliga fem skript i rätt ordning och skriver utdata till filen `crud_report.txt` via `tee`, vilket innebär att resultatet visas i terminalen och sparas till fil samtidigt. Varje steg avgränsas med en tydlig rubrik som anger vilket skript som körs och vad det gör. Eftersom skriptet börjar med att återskapa kollektionen är övningen fullt repeterbar med ett enda kommando.