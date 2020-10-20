# NETCORE Dependency injection


## Provide lambda

lambda that's provided at service registration time describes how to create the service.

```csharp
services.AddSingleton<WeatherForecastService>(provider => 
{
    var dataService = new DataService(); // manual POCO
    return new WeatherForecastService(dataService); // manual creation
});

 services.AddSingleton<WeatherForecastService>(provider => 
{
    var dataService = provider.GetRequiredService<DataService>(); // services.AddSingleton<DataService>(); // Required!
    return new WeatherForecastService(dataService);
});

```


## DI open generic types

```csharp
public class ForecastService<T> where T: new();
{
    private readonly DataService _dataService;
    public ForecastService(DataService dataService)
    {
        _dataService = dataService;
    }

    public IEnumerable<T> GetForecasts() => new List<T>(); // use data 
}

services.AddSingleton(typeof(ForecastService<>));  // registration
ForecastService<WeatherForecast> service // ctor inject
IEnumerable<WeatherForecast> l =  _service.GetForecasts(); // usage
```



### Template 

```csharp


```