# ASPNET CORE

## middleware (request to response pipeline processing)

### One request delegate to handle all request (without pipeline)

app.run() terminates the pipeline

```csharp
public class Startup
{
    public void Configure(IApplicationBuilder app)
    {
    	// using app.run disables pipeline
        app.Run(async context =>  // TERMINAL MIDDLEWARE
        {
            await context.Response.WriteAsync("Hello, World!");
        });
    }
}
```

### Pipeline chaining 

Chain with app.use(). Next means next delegate in pipeline
```csharp
public void Configure(IApplicationBuilder app)
{
    app.Use(async (context, next) =>
    {
        // Do work that doesn't write to the Response.
        await next.Invoke(); // if you avoid this, you have short circuiting
        // Do logging or other work that doesn't write to the Response.
    });

    app.Run(async context =>  // TERMINAL MIDDLEWARE
    {
        await context.Response.WriteAsync("Hello from 2nd delegate.");
    });
}
```

### Branching middleware pipeline

If the request path starts with the given path, the branch is executed.

```csharp
private static void HandleMapTest1(IApplicationBuilder app)
{
    app.Run(async context =>
    {
        await context.Response.WriteAsync("Map Test 1");
    });
}

private static void HandleMapTest2(IApplicationBuilder app)
{
    app.Run(async context =>
    {
        await context.Response.WriteAsync("Map Test 2");
    });
}

private void HandleBranchAndRejoin(IApplicationBuilder app)
{
    app.Use(async (context, next) =>
    {
        // Do work that doesn't write to the Response.
        await next();
        // Do other work that doesn't write to the Response.
    });
}

public void Configure(IApplicationBuilder app)
{
    app.Map("/map1", HandleMapTest1); // branch 1
    app.Map("/map2", HandleMapTest2); // branch 2
    app.Map("/map1/seg1", HandleMultiSeg); // multiple segments
    app.MapWhen(context => context.Request.Query.ContainsKey("branch"), HandleBranch); // match on predicate
    app.UseWhen(context => context.Request.Query.ContainsKey("branch"), HandleBranchAndRejoin); // rejoins
    app.Run(async context => // default branch, not executed if match found
    {
        await context.Response.WriteAsync("Hello from non-Map delegate. <p>");
    });
}
```


### proposed pipeline order

```csharp


```




### Template 

```csharp
if (env.IsDevelopment())
{
    app.UseDeveloperExceptionPage(); //  reports app runtime errors.
    app.UseDatabaseErrorPage(); // reports database runtime errors
}
else
{
    app.UseExceptionHandler("/Error"); // catches exceptions thrown in the following middlewares
    app.UseHsts(); // adds the Strict-Transport-Security header.
}

app.UseHttpsRedirection(); // redirects HTTP requests to HTTPS.
app.UseStaticFiles(); // static files and short-circuits further request processing.
// app.UseCookiePolicy();  // conforms the app to the EU General Data Protection Regulation (GDPR)

app.UseRouting(); // Routing Middleware 
// app.UseRequestLocalization();
// app.UseCors();

app.UseAuthentication(); //  attempts to authenticate the user before they're allowed access to secure resources
app.UseAuthorization(); // authorizes a user to access secure resources
// app.UseSession(); //  establishes and maintains session state. I
// app.UseResponseCaching();

app.UseEndpoints(endpoints =>
{
    endpoints.MapRazorPages();
    endpoints.MapControllerRoute(
        name: "default",
        pattern: "{controller=Home}/{action=Index}/{id?}");
});
```
