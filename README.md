# A cross platform, modularized ecommerce system built on .NET Core

## Online demo (Azure Website)
http://demo.simplcommerce.com

## Description
This app was originally forked from:
https://github.com/simplcommerce/SimplCommerce

Several changes have been made including:
- Migrating base images from Ubuntu to RHEL 7
- Migrating embedded PostgreSQL database to external SQL Server instance
- Injecting SQL Server via the mssql-tools for Linux
- Separating out hardcoded pointers to environment variables
- Various Dockerfile enhancements

For testing SQL Server running in a Docker container with a RHEL base image was used from here:
https://github.com/johnfosborneiii/SQLServerLinux

## Build and run
docker build -f Dockerfile-base-rhel7 -t dotnet-summit-base-rhel7:1.0 .
docker build -t dotnet-summit-app .
docker run -e SQL_SERVER_HOST=$var -e SQL_SERVER_PORT=$var -e SQL_SERVER_USERNAME=$var -e SQL_SERVER_PASSWORD=$var -p 5000:5000 dotnet-summit-app

## Prerequisite:
- SQL Server

## Technologies and frameworks used:
- ASP.NET MVC Core 1.1.0 on .NET Core 1.1.0
- Entity Framework Core 1.1.0
- ASP.NET Identity Core 1.1.0
- Autofac 4.0.0
- Angular 1.5
- MediatR for domain event

## The architecture highlight
![](https://raw.githubusercontent.com/simplcommerce/SimplCommerce/master/simplcommerce.png)

The application is divided into modules. Each module contains all the stuff for itself to run including Controllers, Services, Views and event static files. If a module is no longer need, you can simply just delete it by a single click.

The SimplCommerce.WebHost is the ASP.NET Core project and act as the host. It will bootstrap the app and load all the modules it found in it's Modules folder. In the gulpfile.js, there is a "copy-modules" that is bound to 'AfterBuild' event of Visual Studio to copy /bin, /Views, /wwwroot in each module to the Modules folder in the WebHost.

During the application startup, the host will scan for all the *.dll in the Modules folder and load it up using AssemblyLoadContext. These assemblies then be registered to MVC Core by ApplicationPart

A ModuleViewLocationExpander is implemented to help the ViewEngine can find the right location for views in modules.

Static files (wwwroot) in each module is served by configuring the static files middleware as follows

```cs
    // Serving static file for modules
    foreach (var module in modules)
    {
        var wwwrootDir = new DirectoryInfo(Path.Combine(module.Path, "wwwroot"));
        if (!wwwrootDir.Exists)
        {
            continue;
        }

        app.UseStaticFiles(new StaticFileOptions()
        {
            FileProvider = new PhysicalFileProvider(wwwrootDir.FullName),
            RequestPath = new PathString("/" + module.ShortName)
        });
    }
 ```
#### For entity framework
Every domain entities need to inherit from Entity, then on the "OnModelCreating" method, we find them and register them to DbContext
```cs
    private static void RegisterEntities(ModelBuilder modelBuilder, IEnumerable<Type> typeToRegisters)
    {
        var entityTypes = typeToRegisters.Where(x => x.GetTypeInfo().IsSubclassOf(typeof(Entity)) && !x.GetTypeInfo().IsAbstract);
        foreach (var type in entityTypes)
        {
            modelBuilder.Entity(type);
        }
    }
```
By default domain entities is mapped by convention. In case you need to some special mapping for your model. You can create a class that implement the ICustomModelBuilder for example
```cs
    public class CatalogCustomModelBuilder : ICustomModelBuilder
    {
        public void Build(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<ProductLink>()
                .HasOne(x => x.Product)
                .WithMany(p => p.ProductLinks)
                .HasForeignKey(x => x.ProductId)
                .OnDelete(DeleteBehavior.Restrict);
        }
    }
```

## License
SimplCommerce is licensed under the Apache 2.0 license.
