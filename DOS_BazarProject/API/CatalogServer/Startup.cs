using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Web.Http;
using System.Web.Http.Cors;
using CatalogServer.Data;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.HttpsPolicy;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using Microsoft.OpenApi.Models;
using Newtonsoft.Json.Serialization;

namespace CatalogServer
{
    public class Startup
    {
        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        public IConfiguration Configuration { get; }

        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services)
        {
           
            services.AddControllers().AddNewtonsoftJson(s =>
            {
                s.SerializerSettings.ContractResolver = new CamelCasePropertyNamesContractResolver();
            });//this service used to add controller to the api
            services.AddSwaggerGen(c =>
            {
                c.SwaggerDoc("v1", new OpenApiInfo {Title = "CatalogServer", Version = "v1"});
            });// Adding Swagger Documentation and Configuring Swagger.

            services.AddDbContext<CatalogContext>(opt =>
            {
                opt.UseSqlite(Configuration.GetConnectionString("CatalogConnection"));
            }); //this service usage is to specify the class which will be add as a DataBase context class
                // and specfy the DataBase type that we will use in our case is SqlLite
            
            services.AddScoped<ICatalogRepo, SqlCatalogRepo>();
            //this service used to map between the interface and it implementation
            //the Scoped mean that whenever a ICatalogRepo created it will be inject by the SqlCatalogRepo
            //and it's refare to the lifetime of the service which is connected to Client request (each client has his own serivce)
            
            services.AddAutoMapper(AppDomain.CurrentDomain.GetAssemblies());
            
            // add AutoMapper service to the server 


        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
                app.UseSwagger();
                app.UseSwaggerUI(c => c.SwaggerEndpoint("/swagger/v1/swagger.json", "CatalogServer v1"));
            }
            app.UseRouting(); // allow routing in the server controller
            
            app.UseCors(x => x
                .AllowAnyOrigin()
                .AllowAnyMethod()
                .AllowAnyHeader());
            //allow request from any origin using any method

            app.UseAuthorization();// add Authorization in our http

            app.UseEndpoints(endpoints => { endpoints.MapControllers(); });// Map the controller for their endpoints
        }
        
    }
}
