
# CSHARP Code Snippets

## Debugging utils

1. Trigger debugging breakpoint
```
Debugger.Break();
```

## Statements

### Switch
```
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

### Yield

```
public List<OpcUaNode> Nodes { get; set; }
IEnumerable<OpcUaNode> Flatten(OpcUaNode node)
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

## Datetime

### Parsing
```
DateTime timestamp = DateTime.ParseExact(rs_line, "yyyy-MM-dd HH:mm:ss.fff", CultureInfo.InvariantCulture.DateTimeFormat);
```
### Unix time
```
long timeUnixSeconds = ((DateTimeOffset)DateTime.UtcNow).ToUnixTimeSeconds();
DateTime.UtcNow.ToUnixSeconds();
```
##JSON

1. Deserializing

```
var dd = JsonConvert.DeserializeObject<ConnectorDeltaMsg>(msg,
	new JsonSerializerSettings { ObjectCreationHandling = ObjectCreationHandling.Replace }
);
```


1. Tracing serialization deseralization
```
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
```
foreach ((Device d, _) in cachedDevices.Values.ToList())
{
    d.DeviceDriverDRV?.Stop();
}
```


## Streams

1. Read file line by line
```
string line;
using (StreamReader tr = new StreamReader("file1.txt"))
{
    while ((string line = tr.ReadLine()) != null)
    {
        
    }
};
```

1. Read whole file
```
string json;

using (FileStream fs = confFilePath.Open(FileMode.Open, FileAccess.Read, FileShare.Read))
{
    using (StreamReader r = new StreamReader(fs, Encoding.Default))
    {
        json = r.ReadToEnd();
    }
}
```

1. Write file with stream sync

```
using (FileStream myFileStream = File.Open(queueFile, FileMode.CreateNew, FileAccess.ReadWrite, FileShare.ReadWrite))
{
    using (StreamWriter s = new StreamWriter(myFileStream))
    {
        s.Write(content);
    }
}
```

1. Write file async
```
using (var fileStream = new FileStream(this.fileName, FileMode.Append, FileAccess.Write, FileShare.None, bufferSize: 4096, useAsync: true))
{
    using (StreamWriter s = new StreamWriter(fileStream))
    {
        await s.WriteLineAsync(content);
    }
}
```



1. Text writer and reader
```
using (TextWriter wr = new StreamWriter(serverNodeStructurePath, false))
{
    await wr.WriteAsync(json);
    await wr.FlushAsync();
}
using (TextReader rr = new StreamReader(serverNodeStructurePath))
{
    string json = await rr.ReadToEndAsync();
    nodeFullStructure = JsonConvert.DeserializeObject<OpcUaNodeStructure>(json);
    nodesList = nodeFullStructure.ToSubscriptionFlatNodeList();
}
```


## Threading and concurrency

### Wait for async task
```
Task.Run(ASYNC_METHOD_NAME).GetAwaiter().GetResult(); // block thread until async completes
```

### Execute on background 



## Unit testing

### NMOCK

1. using hardcoded mock

```
private readonly AdapterJsonFileLoggerOptions optsFixture = new AdapterJsonFileLoggerOptions { Dir = "data" };

var mock = new Mock<IOptions<AdapterJsonFileLoggerOptions>>();
IOptions<AdapterJsonFileLoggerOptions> opts = mock.Object;

// We need to set the Value of IOptions to be the SampleOptions Class
mock.Setup(ap => ap.Value).Returns(optsFixture);
```


## Language and CLR

1. Inlining compiler hint

```
[MethodImpl(MethodImplOptions.AggressiveInlining)]
private static bool IsAscii(char c);
```


## Recepies

### Stopwatch

Tracking execution time
```
 long start = DateTimeOffset.Now.ToUnixTimeMilliseconds();
 // time consuming code
_logger.Info("Read complited in {0}", DateTimeOffset.Now.ToUnixTimeMilliseconds() - start);
```




