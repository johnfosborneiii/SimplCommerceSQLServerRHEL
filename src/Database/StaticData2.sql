USE SimplCommerce
GO

SET QUOTED_IDENTIFIER ON

SET IDENTITY_INSERT [dbo].[Core_User] ON 
INSERT [dbo].[Core_User] ([Id], [UserGuid], [FullName], [IsDeleted], [CreatedOn], [UpdatedOn], [UserName], [NormalizedUserName], [Email], [NormalizedEmail], [EmailConfirmed], [PasswordHash], [SecurityStamp], [ConcurrencyStamp], [PhoneNumber], [PhoneNumberConfirmed], [TwoFactorEnabled], [LockoutEnd], [LockoutEnabled], [AccessFailedCount]) VALUES (1, '1FFF10CE-0231-43A2-8B7D-C8DB18504F65', N'Shop Admin', 0, CAST(N'2016-05-12 23:44:13.297' AS DateTime), CAST(N'2016-05-12 23:44:13.297' AS DateTime), N'admin@SimplCommerce.com', N'ADMIN@SIMPLCOMMERCE.COM', N'admin@SimplCommerce.com', N'ADMIN@SIMPLCOMMERCE.COM', 0, N'AQAAAAEAACcQAAAAEAEqSCV8Bpg69irmeg8N86U503jGEAYf75fBuzvL00/mr/FGEsiUqfR0rWBbBUwqtw==', N'9e87ce89-64c0-45b9-8b52-6e0eaa79e5b7', N'8620916f-e6b6-4f12-9041-83737154b338', NULL, 0, 0, NULL, 1, 0)
SET IDENTITY_INSERT [dbo].[Core_User] OFF
GO

