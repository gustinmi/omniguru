# CSHARP Code Snippets

## Debugging utils

### Trigger debugging breakpoint
```csharp
Debugger.Break();
```

### Print stack trace
```csharp
Console.WriteLine(new System.Diagnostics.StackTrace());
```

### Stopwatch time recording

```csharp
private long timeSpentMs = 0;
var watch = new System.Diagnostics.Stopwatch();
watch.Start();
// do something time consuming
watch.Stop();
timeSpentMs += watch.ElapsedMilliseconds;
```


## Language

### var

"var" is not a type. "var" simply means "compiler, the type of this variable is the type of its initializer"

### Cast and type check

#### Is and As operators

```csharp
if ((propExp is string))
    string newVariable = propExp as string;
```

### Merge cast with type check

```csharp
// FactoryUnitEntity factoryUnit = ent as FactoryUnitEntity;
// if (factoryUnit != null) {}
if (ent is FactoryUnitEntity factoryUnit)   // pattern matching
```


### Using statement

```csharp

public sealed class MyStopwatch : IDisposable
{
    Stopwatch _sw;

    public MyStopwatch()
    {
        _sw = Stopwatch.StartNew();
    }

    private bool disposed = false;

    public void Dispose() // called on exiting using block
    {
        if (!disposed)
        {
            Console.Write("{Message}: {ElapsedMilliseconds}ms", _sw.ElapsedMilliseconds);
            disposed = true;
        }
    }
}

using (new MyStopwatch())
{
    // your code
}


```



## Statements

### nameof operator 

Get the method name

```csharp
public static void If(FunctionArgs args) 
{
    if (args == null) throw new ArgumentNullException(nameof(args)); // param name
    throw new Exception($"{nameof(If)}"}; // method name
}
```


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

## Delegates and events

### Assign anonymous delegate handler

```csharp
someDelegate += delegate (string name)/* fun signature args */
    {                              
        return name.ToUpper();   // function body
    };
```

### Custom event args (returning values)

```csharp

public class CustomEventArgs:EventArgs {

    public bool DoOverride { get; set; }
    public string Variable1 { get; private set; }

    public myCustomeEventArgs(string variable1 , string variable2 ){
        DoOverride = false;
        Variable1 = variable1 ;
    }
}

public delegate void myCustomeEventHandler(object sender, myCustomeEventArgs e); // definition of delegate prototype

public event myCustomeEventHandler myCustomeEvent; // event definition

// event fire
var eventArgs = new myCustomeEventArgs("foo", "bar");
myCustomeEvent(this, eventArgs);

//Here you can now with the return of the event work with the event args
if(eventArgs.DoOverride)
{
   //Do Something
}


```

### Event handler as Func delegate 

Encapsulates a method that has one parameter (up to 12 possible) and returns a value of the type specified by the TResult parameter. If event returns a value and there are multiple handlers registered the event returns the result value of the last called handler.

```csharp

// delegate TResult Func<in T,out TResult>(T arg); // parameter and return value

event Func<string, bool> theEvent; // definition

theEvent += new Func<string, bool>(HandlerDelegate); // assign delegate

bool HandlerDelegate(string arg) { return true; } // delegate handler

var r = TheEvent("s"); // trigger event

```

### Event handler as a Action delegate

```csharp
// method that accepts delegate
void SomeMethod(string foo, Action<bool, string> onCompletedAction){
    onCompletedAction(true, ""); // execute
}

// definition of delegate
Action<bool, string> cbAction = delegate (bool success, string log)
{
    Process(success, log); // further processing
};


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

```csharp
internal T TryGetValue<T>(out T value)
{
    
    T value = (T)TypeDescriptor.GetConverter(typeof(T)).ConvertFromString(e.Value);
    return value;
}
```

```csharp
public bool TryGetValue<T>(string key, out T value) where T: class
{
    MyDataItem di;
    if (typeof(T) == typeof(MyDataItem))
    {
        bool ret = TryGetMyDataItem(key, out di);
        value = di as T;
        return ret;
    }

    if (!_dictionary.TryGetValue(key, out di)) 
    {
        value = default(T);
        return false;
    }

    return di.Value.TryGetValue<T>(out value);
}
```

### Generics and reflection - hard copy object

```csharp
public static T Clone<T>(this T item) {
    FieldInfo[] fis = item.GetType().GetFields(BindingFlags.Instance | BindingFlags.Public | BindingFlags.NonPublic);
    object tempMyClass = Activator.CreateInstance(item.GetType());
    foreach (FieldInfo fi in fis)    {
        if (fi.FieldType.Namespace != item.GetType().Namespace)
            fi.SetValue(tempMyClass, fi.GetValue(item));
        else
        {
            object obj = fi.GetValue(item);
            if (obj != null)
                fi.SetValue(tempMyClass, obj.Clone());
        }
    }
    return (T)tempMyClass;
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

### Checking json token type 

```csharp
(value is JToken && (value as JToken).Type == JTokenType.Null)
```

## Write json effective

```csharp
var json = new JObject(
        new JProperty("status", result.Status.ToString()),
        new JProperty("results", new JObject(result.Entries.Select(pair =>
            new JProperty(pair.Key, new JObject(
                new JProperty("status", pair.Value.Status.ToString()),
                new JProperty("description", pair.Value.Description),
                new JProperty("data", new JObject(pair.Value.Data.Select(
                    p => new JProperty(p.Key, p.Value))))))))));

json.ToString(Formatting.Indented); // to string
```


### Deserializing

#### To dictionary

```csharp
Dictionary<string, object> dd = JsonConvert.DeserializeObject<ConnectorDeltaMsg>(msg,
	new JsonSerializerSettings { ObjectCreationHandling = ObjectCreationHandling.Replace }
);
```

#### To POCO object

```csharp
Album album = jalbum.ToObject<Album>();
```


### Tracing serialization deseralization
```csharp

//DiagnosticsTraceWriter diagTrace = new DiagnosticsTraceWriter();
//diagTrace.LevelFilter = System.Diagnostics.TraceLevel.Verbose;

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

### List static init

```csharp
new List<EntityType>() {EntityType.Company, EntityType.CompanyUnit, EntityType.Device, EntityType.DeviceGroup}
```

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

### Task.run

The Task.Run method queues code to run on a different thread (usually from the "thread pool").
Task.Run returns a Task which means you can use the await keyword with it

await >> IO bound operations
Task.Run >> CPU bounded operations 


```csharp
void MySyncMethod(){
    Task.Run(() => _sim.TriggerMergeFiles());
}
```


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

### Monitor

```csharp
bool lockTaken = false;  // prevent leaked lock
try
{
    // Determines whether the current thread holds the lock on the specified object.
    // if (Monitor.IsEntered(lockContextObject))      

    Monitor.Enter(lockContextObject, ref lockTaken);  // enter lock, specific lockContextObject (this, or collection, or object

}
finally
{
    if (lockTaken) Monitor.Exit(lockContextObject);
}
```

###  ReadWrite Lock

1. Create lock

```csharp
private readonly ReaderWriterLockSlim readWriteLock = new ReaderWriterLockSlim();
```

1. Read lock
```csharp
try
{
    readWriteLock.EnterReadLock();
    
}
finally
{
    readWriteLock.ExitReadLock();
}
```

1. Write lock
```csharp
try
{
    this.readWriteLock.EnterWriteLock();
}
finally
{
    this.readWriteLock.ExitWriteLock();
}
```


### Linked cancelation token

```csharp
var timeoutToken = new CancellationTokenSource(Options.ShutdownTimeout).Token;
if (!cancellationToken.CanBeCanceled)
{
    cancellationToken = timeoutToken;
}
else
{
    cancellationToken = CancellationTokenSource.CreateLinkedTokenSource(cancellationToken, timeoutToken).Token;
}
```


### Wait for async task

In an async operation, you spin up a new thread, wait for the thread to start, and then rejoin the original call. 

The await keyword will by default wait for a task to complete and attempt to join the original SynchronizationContext that started the operation.

Await captures the current SynchronizationContext, which includes information about the current thread, and by default automatically returns to that thread when finished.

### Run async method as a task in sync method

```csharp
void MySyncMethod(){
    Task.Run(() => _sim.TriggerMergeFiles());
}
```

#### Wait on  result property value

```csharp
async Task<bool> LoadFirstTime(){
    await Task.Delay(1000);
}

// await on task via Result properts
if (LoadFirstTime().Result == false)
```

#### Via Wait()

```csharp
Task.Run(() => ReadConfiguration()).Wait();
```

#### Execute task wait on result sync

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

### Get property values of object

```csharp
Type t = e.GetType();
IList<PropertyInfo> props = new List<PropertyInfo>(t.GetProperties());
foreach (PropertyInfo prop in props) {
    if (prop.Name == "X") {
        object propValue = prop.GetValue(e, null);
        _x = Convert.ToInt32(propValue);
    }
}
```

### Enums

#### Enumerate enum members

```csharp
foreach (EntityType suit in (EntityType[])Enum.GetValues(typeof(EntityType))){}
```

#### Enum from string name

```csharp
string stringValue = Enum.GetName(typeof(EnumDisplayStatus), dbValue);
```

#### Enum from object 
```csharp
isPrimaryController = (PrimaryController) Enum.ToObject(typeof(PrimaryController), primaryControllerStr);
```

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

### Get all interface implementors from assembly

```csharp
// searchin all types implementing IAutostartService
foreach (var a in AppDomain.CurrentDomain.GetAssemblies().SelectMany(x => x.GetTypes())
    .Where(x => typeof(IAutostartService).IsAssignableFrom(x)))
{
    autostartServices.AddRange(services.Where(s => s.ImplementationType == a));
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

### Using expando object to constrtuct jobject

```csharp
// workaround : remap related entititzes into jobject 
dynamic relatedEntititesWrapper = new ExpandoObject();
relatedEntititesWrapper.RelatedEntities = simIndex.RelatedEntities;
simIndexToSave.SetContent(JObject.FromObject(relatedEntititesWrapper));
```

## Logging

### Nlog create logger

#### Create logger from config and use it right away

```csharp
protected static Logger logger = NLogBuilder.ConfigureNLog("nlog.config").GetCurrentClassLogger();
```

#### From logger manager

```csharp
protected static readonly Logger logger = LogManager.GetCurrentClassLogger();
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

### Console

```csharp
Console.ForegroundColor = ConsoleColor.White;
Console.WriteLine("Enter a greeting to send and press ENTER: ");
Console.Write(">>> ");
Console.ForegroundColor = ConsoleColor.Green;
string greeting = Console.ReadLine();
```

### Regular expressions

```csharp
public static string GetTitleFromHtml(string html)
{
    Match match = new Regex(@".*<head>.*<title>(.*)</title>.*</head>.*", RegexOptions.IgnoreCase | RegexOptions.Singleline).Match(html);
    return match.Success ? match.Groups[1].Value : null;
}
```

### Manual stopwatch - Tracking execution time
```csharp
 long start = DateTimeOffset.Now.ToUnixTimeMilliseconds();
 // time consuming code
_logger.Info("Read complited in {0}", DateTimeOffset.Now.ToUnixTimeMilliseconds() - start);
```

### String interpolation

```csharp
string tmpl = @"We have {@controller} with {@device}"; // template setup
string res = Interpolate(tmpl); // We have ctrl1 with Dev2

string Interpolate(string template) {
    if (template == null) throw new ArgumentNullException(nameof(template), "Empty template");
    
    var parameters = new Dictionary<string, object>();
    parameters.Add("{@controller}", "ctrl1"); // set somehow
    parameters.Add("{@device}", "Dev2"); // set somehow
    
    string str = parameters.Aggregate(template, (current, parameter) => current.Replace(parameter.Key, parameter.Value.ToString()));
    return str;
}
```

### GC memorty management

```csharp
GC.Collect(2, GCCollectionMode.Forced, true, true); // forcefully collect
 ```

# Documentation

## Explaining code 

### Indicating which exceptions are thrown

```xml
<exception cref="T:System.ArgumentOutOfRangeException">
```
	
## References

## Referencing class with 

```xml
<see cref="P:System.ServiceModel.Dispatcher.ClientRuntime.MessageInspectors" />
```

### Referencing parameter

```xml
<paramref name="correlationState" />
```

### Referencing build-in keyword
```xml
<see langword="null" />
```



