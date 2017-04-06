using System.IO;
using Microsoft.AspNetCore.Hosting;

namespace SimplCommerce.WebHost
{
    public class Program
    {
        public static void Main(string[] args)
        {
            var host = new WebHostBuilder()
		.UseUrls("http://*:1000", "https://*:1234", "http://0.0.0.0:5000")
                .UseKestrel()
                .UseContentRoot(Directory.GetCurrentDirectory())
                .UseIISIntegration()
                .UseStartup<Startup>()
                .Build();

            host.Run();
        }
    }
}
