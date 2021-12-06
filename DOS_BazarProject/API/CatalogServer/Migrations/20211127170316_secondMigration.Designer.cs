﻿// <auto-generated />
using System;
using CatalogServer.Data;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.Migrations;
using Microsoft.EntityFrameworkCore.Storage.ValueConversion;

namespace CatalogServer.Migrations
{
    [DbContext(typeof(CatalogContext))]
    [Migration("20211127170316_secondMigration")]
    partial class secondMigration
    {
        protected override void BuildTargetModel(ModelBuilder modelBuilder)
        {
#pragma warning disable 612, 618
            modelBuilder
                .HasAnnotation("ProductVersion", "5.0.10");

            modelBuilder.Entity("CatalogServer.Model.Book", b =>
                {
                    b.Property<Guid>("Id")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("TEXT");

                    b.Property<double>("BookCost")
                        .HasColumnType("REAL");

                    b.Property<string>("BookName")
                        .IsRequired()
                        .HasColumnType("TEXT");

                    b.Property<string>("BookTopic")
                        .IsRequired()
                        .HasColumnType("TEXT");

                    b.Property<int>("CountInStock")
                        .HasColumnType("INTEGER");

                    b.HasKey("Id");

                    b.ToTable("Catalogs");
                });
#pragma warning restore 612, 618
        }
    }
}