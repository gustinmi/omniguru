# CSHARP Code Snippets

## Debugging utils

### Trigger debugging breakpoint
```csharp
Debugger.Break();
```

## Statements

### Switch with filters
```csharp
switch (collection)
{
	case null:
	  throw new ArgumentNullException(nameof (collection));
	case HashSet<T> objSet when HashSet<T>.AreEqualityComparersEqual(this, objSet):
	  this.CopyFrom(objSet);
	  return;
	case ICollection<T> objs:
	  capacity = objs.Count;
	  break;
	default:
	  capacity = 0;
	  break;
}
```

### Yield break and return
```csharp
public List<SomeNode> Nodes { get; set; }
IEnumerable<SomeNode> Flatten(SomeNode node)
{
    yield return node;
    if (node.SubNodes == null)
    { // or it's got .Count==0, your call
        yield break; // end the iteration
    }
    foreach (var child in node.SubNodes)
    {
        foreach (var flattenedNode in Flatten(child))
        {
            yield return flattenedNode;
        }
    }
}
```

## Object ORIENTED 

### Dynamic object (no strong typing)

```csharp
dynamic jsonObject = new JObject();
jsonObject.Date = DateTime.Now;
jsonObject.Album = "Me Against the world";
jsonObject.Year = 1995;
jsonObject.Artist = "2Pac";
```

## Generics

### Generic (extension) method with casting

```csharp
public static T GetValue<T>(this IDictionary<string, object> dict, string key)
{
    if (dict == null) throw new ArgumentNullException(nameof(dict));
    if (key == null) throw new ArgumentNullException(nameof(key));

    object v = dict[key];
    if (v is T)
    {
        return (T)v;
    }

    return (T)Convert.ChangeType(v, typeof(T)); ;
}
```

## Datetime

### Parsing
```csharp
DateTime timestamp = DateTime.ParseExact(rs_line, "yyyy-MM-dd HH:mm:ss.fff", CultureInfo.InvariantCulture.DateTimeFormat);
```
### Unix time
```csharp
long timeUnixSeconds = ((DateTimeOffset)DateTime.UtcNow).ToUnixTimeSeconds();
DateTime.UtcNow.ToUnixSeconds();
```
## JSON via Newtonsoft JSON.NET

### Deserializing

```csharp
var dd = JsonConvert.DeserializeObject<ConnectorDeltaMsg>(msg,
	new JsonSerializerSettings { ObjectCreationHandling = ObjectCreationHandling.Replace }
);
```


### Tracing serialization deseralization
```csharp
ITraceWriter traceWriter = new MemoryTraceWriter();
TestJson state = JsonConvert.DeserializeObject<TestJson>(value,
	new JsonSerializerSettings { 
		ObjectCreationHandling = ObjectCreationHandling.Replace,
		TraceWriter = traceWriter,
		Converters = { new JavaScriptDateTimeConverter() }
	}
);
```

## Collections

### Dictionary

#### Deconstruction
```csharp
foreach ((Device d, _) in cachedDevices.Values.ToList())
{
    d.DeviceDriverDRV?.Stop();
}
```

## Streams

### Read file as byte array
```csharp
byte[] arr = File.ReadAllBytes(@"C:\TEMP\test.json");
```


### Read file line by line
```csharp
string line;
using (StreamReader tr = new StreamReader(@"C:\TEMP\test.json"))
{
    while ((string line = tr.ReadLine()) != null)
    {
        
    }
};
```

### Read whole file
```csharp
string json;
FileInfo f = new FileInfo(@"C:\TEMP\test.json");
using (FileStream fs = f.Open(FileMode.Open, FileAccess.Read, FileShare.Read))
{
    using (StreamReader r = new StreamReader(fs, Encoding.Default))
    {
        json = r.ReadToEnd();
    }
}
```

### Write file

```csharp
File.WriteAllText(@"C:\TEMP\test.json", "[1,2,3]")
```

### Write file with stream sync

```csharp
using (FileStream myFileStream = File.Open(queueFile, FileMode.CreateNew, FileAccess.ReadWrite, FileShare.ReadWrite))
{
    using (StreamWriter s = new StreamWriter(myFileStream))
    {
        s.Write(content);
    }
}
```

### Write file async
```csharp
using (var fileStream = new FileStream(this.fileName, FileMode.Append, FileAccess.Write, FileShare.None, bufferSize: 4096, useAsync: true))
{
    using (StreamWriter s = new StreamWriter(fileStream))
    {
        await s.WriteLineAsync(content);
    }
}
```

### Text writer and reader
```csharp
using (TextWriter wr = new StreamWriter(serverNodeStructurePath, false))
{
    await wr.WriteAsync(json);
    await wr.FlushAsync();
}
using (TextReader rr = new StreamReader(serverNodeStructurePath))
{
    string json = await rr.ReadToEndAsync();
    nodeFullStructure = JsonConvert.DeserializeObject<SomeNodeStructure>(json);
    nodesList = nodeFullStructure.ToSubscriptionFlatNodeList();
}
```
### Using File class
```csharp
File.WriteAllText(fileName, stringContents); 
```

### Touch file
```csharp
File.SetLastWriteTimeUtc(fileName, DateTime.UtcNow);
```

## Threading and concurrency

### Get current thread id
```csharp
Thread.CurrentThread.ManagedThreadId
```

### Wait handle

```csharp

// Thread 1

// create handle, not signaled (false)
EventWaitHandle waiter = new EventWaitHandle(false, EventResetMode.ManualReset);

// we shall wait until signaled 
waiter.WaitOne()
// CODE BEYOND is not executed until unblocked

// Thread 2 

waiter.Set(); // signal to unblock
waiter.Reset(); // set to block

```



### Wait for async task

#### Execute wrapper task

```csharp
Task.Run(ASYNC_METHOD_NAME).GetAwaiter().GetResult(); // block thread until async completes
```

#### Via Result property

```csharp
var r = producer.ProduceAsync(tempTopic.Name, new Message<Null, string> { Value = "a message" }).Result;
Assert.True(r.Status == PersistenceStatus.Persisted);
```

### Lazy initialization

```csharp
// Lazy helper to allow runtime check for Mono: usgae bool isM = IsRunningOnMono();
private static readonly Lazy<bool> IsRunningOnMonoValue = new Lazy<bool>(() => // create and init
{
    return Type.GetType("Mono.Runtime") != null;
});
```

## Linq for object

```csharp
var configuredOptionTypes =
    from descriptor in services
    let serviceType = descriptor.ServiceType
    where serviceType.IsGenericType
    where serviceType.GetGenericTypeDefinition() == typeof(IConfigureNamedOptions<>)
    let optionType = serviceType.GetGenericArguments()[0]
    select optionType;
```

## Reflection

### Get method name

```csharp
MethodBase.GetCurrentMethod()
```

### Execute all methods marked with attribute

```csharp
foreach (var methodInfo in tst.GetType().GetMethods())
{
    var containsInvokeAttribute = methodInfo.GetCustomAttributes(typeof(TestMethodAttribute)).Any();
    if (containsInvokeAttribute)
    {
        logger.Info($"Invoking {methodInfo.Name}");
        methodInfo.Invoke(tst, null);
    }
}
```

## Json handling

### Parse json to dictionary like wrapper

From string variable

```csharp
JObject jo = JObject.Parse((string) msgContents);
```

From inline string

```csharp
JObject  o = JObject.Parse(@"{
  'CPU': 'Intel',
  'Drives': [
    'DVD read/writer',
    '500 gigabyte hard drive'
  ]
}");
```

### Parse json to POCO
```csharp
MyClass poco = JsonConvert.DeserializeObject<MyClass>("{\"a\" : 1}");
```

### Serialize json to string
```csharp
string value = JsonConvert.SerializeObject(someObj);
```

### Construction using JObject JArray

```csharp
JArray arr = new JArray();
JObject c = new JObject();
c["Type"] = "Capacitor";
c["Name"] = "Capacitor";
arr.Add(c);
JObject d = new JObject();
d["Type"] = "Fan";
d["Name"] = "Fan";
arr.Add(d);
```

## Unit testing

### NMOCK

#### Using hardcoded object as mock value

```csharp
private readonly AdapterJsonFileLoggerOptions optsFixture = new AdapterJsonFileLoggerOptions { Dir = "data" };

var mock = new Mock<IOptions<AdapterJsonFileLoggerOptions>>();
IOptions<AdapterJsonFileLoggerOptions> opts = mock.Object;

// We need to set the Value of IOptions to be the SampleOptions Class
mock.Setup(ap => ap.Value).Returns(optsFixture);
```

#### Hardcoded async method call mock 

```csharp
// Task<Guid?> ExistsAsync(string ip, ushort listenerPort);
var repoMock = new Mock<IConnectorService>();
repoMock.Setup(x => x.ExistsAsync("192.168.3.10", 6666)).ReturnsAsync(new Guid("380befcf-74ac-4ac3-8d65-590cee11fce1"));
```

```csharp
 repoMock.Setup(x => x.ExistsAsync(It.IsAny<string>(), It.IsAny<ushort>()))
    .Returns<string, ushort>((x, y) => Task.FromResult(allConnectors.FirstOrDefault(a => a.IP == x && a.ListenerPort == y)?.ConnectorID));
```

```csharp
// Task<Guid?> RegisterAsync(string ip, ushort listenerPort, string description);
repoMock.Setup(x => x.RegisterAsync(It.IsAny<string>(), It.IsAny<ushort>(), It.IsAny<string>()))
    .Callback<string, ushort, string>((x, y, z) => allConnectors.Add(new Connector() { IP = x, ListenerPort = y, Description = z, ConnectorID = Guid.NewGuid() }))
    .ReturnsAsync(() => allConnectors[allConnectors.Count - 1].ConnectorID);
```


## Language and CLR

### Inlining compiler hint

```csharp
[MethodImpl(MethodImplOptions.AggressiveInlining)]
private static bool IsAscii(char c);
```


## Recepies

### Manual stopwatch - Tracking execution time
```csharp
 long start = DateTimeOffset.Now.ToUnixTimeMilliseconds();
 // time consuming code
_logger.Info("Read complited in {0}", DateTimeOffset.Now.ToUnixTimeMilliseconds() - start);
```




