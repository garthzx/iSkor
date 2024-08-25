IF OBJECT_ID(N'[__EFMigrationsHistory]') IS NULL
BEGIN
    CREATE TABLE [__EFMigrationsHistory] (
        [MigrationId] nvarchar(150) NOT NULL,
        [ProductVersion] nvarchar(32) NOT NULL,
        CONSTRAINT [PK___EFMigrationsHistory] PRIMARY KEY ([MigrationId])
    );
END;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231127172649_Initial')
BEGIN
    CREATE TABLE [AspNetRoles] (
        [Id] nvarchar(450) NOT NULL,
        [Name] nvarchar(256) NULL,
        [NormalizedName] nvarchar(256) NULL,
        [ConcurrencyStamp] nvarchar(max) NULL,
        CONSTRAINT [PK_AspNetRoles] PRIMARY KEY ([Id])
    );
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231127172649_Initial')
BEGIN
    CREATE TABLE [AspNetUsers] (
        [Id] nvarchar(450) NOT NULL,
        [Discriminator] nvarchar(max) NOT NULL,
        [FirstName] nvarchar(max) NULL,
        [LastName] nvarchar(max) NULL,
        [UserName] nvarchar(256) NULL,
        [NormalizedUserName] nvarchar(256) NULL,
        [Email] nvarchar(256) NULL,
        [NormalizedEmail] nvarchar(256) NULL,
        [EmailConfirmed] bit NOT NULL,
        [PasswordHash] nvarchar(max) NULL,
        [SecurityStamp] nvarchar(max) NULL,
        [ConcurrencyStamp] nvarchar(max) NULL,
        [PhoneNumber] nvarchar(max) NULL,
        [PhoneNumberConfirmed] bit NOT NULL,
        [TwoFactorEnabled] bit NOT NULL,
        [LockoutEnd] datetimeoffset NULL,
        [LockoutEnabled] bit NOT NULL,
        [AccessFailedCount] int NOT NULL,
        CONSTRAINT [PK_AspNetUsers] PRIMARY KEY ([Id])
    );
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231127172649_Initial')
BEGIN
    CREATE TABLE [AspNetRoleClaims] (
        [Id] int NOT NULL IDENTITY,
        [RoleId] nvarchar(450) NOT NULL,
        [ClaimType] nvarchar(max) NULL,
        [ClaimValue] nvarchar(max) NULL,
        CONSTRAINT [PK_AspNetRoleClaims] PRIMARY KEY ([Id]),
        CONSTRAINT [FK_AspNetRoleClaims_AspNetRoles_RoleId] FOREIGN KEY ([RoleId]) REFERENCES [AspNetRoles] ([Id]) ON DELETE CASCADE
    );
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231127172649_Initial')
BEGIN
    CREATE TABLE [AspNetUserClaims] (
        [Id] int NOT NULL IDENTITY,
        [UserId] nvarchar(450) NOT NULL,
        [ClaimType] nvarchar(max) NULL,
        [ClaimValue] nvarchar(max) NULL,
        CONSTRAINT [PK_AspNetUserClaims] PRIMARY KEY ([Id]),
        CONSTRAINT [FK_AspNetUserClaims_AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [AspNetUsers] ([Id]) ON DELETE CASCADE
    );
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231127172649_Initial')
BEGIN
    CREATE TABLE [AspNetUserLogins] (
        [LoginProvider] nvarchar(450) NOT NULL,
        [ProviderKey] nvarchar(450) NOT NULL,
        [ProviderDisplayName] nvarchar(max) NULL,
        [UserId] nvarchar(450) NOT NULL,
        CONSTRAINT [PK_AspNetUserLogins] PRIMARY KEY ([LoginProvider], [ProviderKey]),
        CONSTRAINT [FK_AspNetUserLogins_AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [AspNetUsers] ([Id]) ON DELETE CASCADE
    );
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231127172649_Initial')
BEGIN
    CREATE TABLE [AspNetUserRoles] (
        [UserId] nvarchar(450) NOT NULL,
        [RoleId] nvarchar(450) NOT NULL,
        CONSTRAINT [PK_AspNetUserRoles] PRIMARY KEY ([UserId], [RoleId]),
        CONSTRAINT [FK_AspNetUserRoles_AspNetRoles_RoleId] FOREIGN KEY ([RoleId]) REFERENCES [AspNetRoles] ([Id]) ON DELETE CASCADE,
        CONSTRAINT [FK_AspNetUserRoles_AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [AspNetUsers] ([Id]) ON DELETE CASCADE
    );
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231127172649_Initial')
BEGIN
    CREATE TABLE [AspNetUserTokens] (
        [UserId] nvarchar(450) NOT NULL,
        [LoginProvider] nvarchar(450) NOT NULL,
        [Name] nvarchar(450) NOT NULL,
        [Value] nvarchar(max) NULL,
        CONSTRAINT [PK_AspNetUserTokens] PRIMARY KEY ([UserId], [LoginProvider], [Name]),
        CONSTRAINT [FK_AspNetUserTokens_AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [AspNetUsers] ([Id]) ON DELETE CASCADE
    );
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231127172649_Initial')
BEGIN
    CREATE TABLE [Events] (
        [EventId] uniqueidentifier NOT NULL,
        [EventName] nvarchar(max) NOT NULL,
        [EventStartDate] datetime2 NULL,
        [EventEndDate] datetime2 NULL,
        [Url] nvarchar(450) NOT NULL,
        [ApplicationUserId] nvarchar(450) NOT NULL,
        CONSTRAINT [PK_Events] PRIMARY KEY ([EventId]),
        CONSTRAINT [FK_Events_AspNetUsers_ApplicationUserId] FOREIGN KEY ([ApplicationUserId]) REFERENCES [AspNetUsers] ([Id]) ON DELETE CASCADE
    );
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231127172649_Initial')
BEGIN
    CREATE TABLE [Categories] (
        [CategoryId] uniqueidentifier NOT NULL,
        [Name] nvarchar(max) NOT NULL,
        [EventId] uniqueidentifier NULL,
        CONSTRAINT [PK_Categories] PRIMARY KEY ([CategoryId]),
        CONSTRAINT [FK_Categories_Events_EventId] FOREIGN KEY ([EventId]) REFERENCES [Events] ([EventId])
    );
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231127172649_Initial')
BEGIN
    CREATE TABLE [Teams] (
        [TeamId] uniqueidentifier NOT NULL,
        [Abbreviation] nvarchar(max) NULL,
        [FullName] nvarchar(max) NOT NULL,
        [EventId] uniqueidentifier NULL,
        CONSTRAINT [PK_Teams] PRIMARY KEY ([TeamId]),
        CONSTRAINT [FK_Teams_Events_EventId] FOREIGN KEY ([EventId]) REFERENCES [Events] ([EventId])
    );
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231127172649_Initial')
BEGIN
    CREATE TABLE [Competitions] (
        [CompetitionId] uniqueidentifier NOT NULL,
        [Name] nvarchar(max) NOT NULL,
        [Description] nvarchar(max) NULL,
        [EventId] uniqueidentifier NULL,
        [CategoryId] uniqueidentifier NULL,
        CONSTRAINT [PK_Competitions] PRIMARY KEY ([CompetitionId]),
        CONSTRAINT [FK_Competitions_Categories_CategoryId] FOREIGN KEY ([CategoryId]) REFERENCES [Categories] ([CategoryId]),
        CONSTRAINT [FK_Competitions_Events_EventId] FOREIGN KEY ([EventId]) REFERENCES [Events] ([EventId])
    );
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231127172649_Initial')
BEGIN
    CREATE TABLE [ApplicationUserCompetition] (
        [CompetitionsCompetitionId] uniqueidentifier NOT NULL,
        [JudgesId] nvarchar(450) NOT NULL,
        CONSTRAINT [PK_ApplicationUserCompetition] PRIMARY KEY ([CompetitionsCompetitionId], [JudgesId]),
        CONSTRAINT [FK_ApplicationUserCompetition_AspNetUsers_JudgesId] FOREIGN KEY ([JudgesId]) REFERENCES [AspNetUsers] ([Id]) ON DELETE CASCADE,
        CONSTRAINT [FK_ApplicationUserCompetition_Competitions_CompetitionsCompetitionId] FOREIGN KEY ([CompetitionsCompetitionId]) REFERENCES [Competitions] ([CompetitionId]) ON DELETE CASCADE
    );
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231127172649_Initial')
BEGIN
    CREATE TABLE [Contestants] (
        [ContestantId] uniqueidentifier NOT NULL,
        [FirstName] nvarchar(max) NOT NULL,
        [LastName] nvarchar(max) NOT NULL,
        [EventId] uniqueidentifier NULL,
        [TeamId] uniqueidentifier NULL,
        [CompetitionId] uniqueidentifier NULL,
        CONSTRAINT [PK_Contestants] PRIMARY KEY ([ContestantId]),
        CONSTRAINT [FK_Contestants_Competitions_CompetitionId] FOREIGN KEY ([CompetitionId]) REFERENCES [Competitions] ([CompetitionId]),
        CONSTRAINT [FK_Contestants_Events_EventId] FOREIGN KEY ([EventId]) REFERENCES [Events] ([EventId]),
        CONSTRAINT [FK_Contestants_Teams_TeamId] FOREIGN KEY ([TeamId]) REFERENCES [Teams] ([TeamId])
    );
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231127172649_Initial')
BEGIN
    CREATE TABLE [Criteria] (
        [CriterionId] uniqueidentifier NOT NULL,
        [Name] nvarchar(max) NOT NULL,
        [PercentFromTotal] decimal(10,5) NOT NULL,
        [Description] nvarchar(max) NULL,
        [CompetitionId] uniqueidentifier NULL,
        CONSTRAINT [PK_Criteria] PRIMARY KEY ([CriterionId]),
        CONSTRAINT [FK_Criteria_Competitions_CompetitionId] FOREIGN KEY ([CompetitionId]) REFERENCES [Competitions] ([CompetitionId])
    );
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231127172649_Initial')
BEGIN
    CREATE TABLE [Scores] (
        [ScoreId] uniqueidentifier NOT NULL,
        [CriterionScore] decimal(10,5) NOT NULL,
        [CriterionId] uniqueidentifier NOT NULL,
        [Remarks] nvarchar(max) NULL,
        CONSTRAINT [PK_Scores] PRIMARY KEY ([ScoreId]),
        CONSTRAINT [FK_Scores_Criteria_CriterionId] FOREIGN KEY ([CriterionId]) REFERENCES [Criteria] ([CriterionId]) ON DELETE CASCADE
    );
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231127172649_Initial')
BEGIN
    IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'Id', N'AccessFailedCount', N'ConcurrencyStamp', N'Discriminator', N'Email', N'EmailConfirmed', N'FirstName', N'LastName', N'LockoutEnabled', N'LockoutEnd', N'NormalizedEmail', N'NormalizedUserName', N'PasswordHash', N'PhoneNumber', N'PhoneNumberConfirmed', N'SecurityStamp', N'TwoFactorEnabled', N'UserName') AND [object_id] = OBJECT_ID(N'[AspNetUsers]'))
        SET IDENTITY_INSERT [AspNetUsers] ON;
    EXEC(N'INSERT INTO [AspNetUsers] ([Id], [AccessFailedCount], [ConcurrencyStamp], [Discriminator], [Email], [EmailConfirmed], [FirstName], [LastName], [LockoutEnabled], [LockoutEnd], [NormalizedEmail], [NormalizedUserName], [PasswordHash], [PhoneNumber], [PhoneNumberConfirmed], [SecurityStamp], [TwoFactorEnabled], [UserName])
    VALUES (N''0c1445ea-4bac-4682-b39a-3a4889c258d0'', 0, N''e912fc98-6166-46fc-81e9-f57ca66eb6fd'', N''ApplicationUser'', N''admindummy@gmail.com'', CAST(1 AS bit), N''Dummy'', N''Dummy'', CAST(0 AS bit), NULL, N''ADMINDUMMY@GMAIL.COM'', N''ADMINDUMMY@GMAIL.COM'', N''AQAAAAEAACcQAAAAEKbKv1mhzflSpziHPvmSaJXtULhVcwSar6BcZ8np5vSvZnEugYLtM0j88bE5O8ckSw=='', N''09156390954'', CAST(1 AS bit), N''00000000-0000-0000-0000-000000000000'', CAST(0 AS bit), N''admindummy@gmail.com'')');
    IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'Id', N'AccessFailedCount', N'ConcurrencyStamp', N'Discriminator', N'Email', N'EmailConfirmed', N'FirstName', N'LastName', N'LockoutEnabled', N'LockoutEnd', N'NormalizedEmail', N'NormalizedUserName', N'PasswordHash', N'PhoneNumber', N'PhoneNumberConfirmed', N'SecurityStamp', N'TwoFactorEnabled', N'UserName') AND [object_id] = OBJECT_ID(N'[AspNetUsers]'))
        SET IDENTITY_INSERT [AspNetUsers] OFF;
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231127172649_Initial')
BEGIN
    IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'EventId', N'ApplicationUserId', N'EventEndDate', N'EventName', N'EventStartDate', N'Url') AND [object_id] = OBJECT_ID(N'[Events]'))
        SET IDENTITY_INSERT [Events] ON;
    EXEC(N'INSERT INTO [Events] ([EventId], [ApplicationUserId], [EventEndDate], [EventName], [EventStartDate], [Url])
    VALUES (''e21d0e2d-f692-4e4a-a421-d7f8bcb06fef'', N''0c1445ea-4bac-4682-b39a-3a4889c258d0'', NULL, N''Foundation Week 2024 '', NULL, N''GxpNbmiJ'')');
    IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'EventId', N'ApplicationUserId', N'EventEndDate', N'EventName', N'EventStartDate', N'Url') AND [object_id] = OBJECT_ID(N'[Events]'))
        SET IDENTITY_INSERT [Events] OFF;
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231127172649_Initial')
BEGIN
    IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'CategoryId', N'EventId', N'Name') AND [object_id] = OBJECT_ID(N'[Categories]'))
        SET IDENTITY_INSERT [Categories] ON;
    EXEC(N'INSERT INTO [Categories] ([CategoryId], [EventId], [Name])
    VALUES (''2724af1d-aa58-4c82-bcf2-7bd944038da4'', ''e21d0e2d-f692-4e4a-a421-d7f8bcb06fef'', N''Socio-Cultural''),
    (''51860641-f544-437a-a351-aefb8edb46d0'', ''e21d0e2d-f692-4e4a-a421-d7f8bcb06fef'', N''Literary'')');
    IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'CategoryId', N'EventId', N'Name') AND [object_id] = OBJECT_ID(N'[Categories]'))
        SET IDENTITY_INSERT [Categories] OFF;
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231127172649_Initial')
BEGIN
    IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'TeamId', N'Abbreviation', N'EventId', N'FullName') AND [object_id] = OBJECT_ID(N'[Teams]'))
        SET IDENTITY_INSERT [Teams] ON;
    EXEC(N'INSERT INTO [Teams] ([TeamId], [Abbreviation], [EventId], [FullName])
    VALUES (''2c510245-4c0c-4d48-b242-f5303e7ea042'', N''SABH'', ''e21d0e2d-f692-4e4a-a421-d7f8bcb06fef'', N''School of Accountancy, Business, and Hospitality''),
    (''49ef35ab-a315-4858-ad1c-ba4aa9777c56'', N''SEAITE'', ''e21d0e2d-f692-4e4a-a421-d7f8bcb06fef'', N''School of Engineering Architecture and Information Technology Education''),
    (''7c9fe5c0-5733-4a9b-80b2-b8277c1dd01f'', N''SEAS'', ''e21d0e2d-f692-4e4a-a421-d7f8bcb06fef'', N''School of Education, Arts, and Sciences''),
    (''c133c1b9-4727-4431-9281-acf11415dc34'', N''SHAS'', ''e21d0e2d-f692-4e4a-a421-d7f8bcb06fef'', N''School of Health and Allied Sciences'')');
    IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'TeamId', N'Abbreviation', N'EventId', N'FullName') AND [object_id] = OBJECT_ID(N'[Teams]'))
        SET IDENTITY_INSERT [Teams] OFF;
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231127172649_Initial')
BEGIN
    IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'CompetitionId', N'CategoryId', N'Description', N'EventId', N'Name') AND [object_id] = OBJECT_ID(N'[Competitions]'))
        SET IDENTITY_INSERT [Competitions] ON;
    EXEC(N'INSERT INTO [Competitions] ([CompetitionId], [CategoryId], [Description], [EventId], [Name])
    VALUES (''3be3d386-365a-4563-8a8f-233cb2ddafef'', ''2724af1d-aa58-4c82-bcf2-7bd944038da4'', NULL, ''e21d0e2d-f692-4e4a-a421-d7f8bcb06fef'', N''Hiphop'')');
    IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'CompetitionId', N'CategoryId', N'Description', N'EventId', N'Name') AND [object_id] = OBJECT_ID(N'[Competitions]'))
        SET IDENTITY_INSERT [Competitions] OFF;
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231127172649_Initial')
BEGIN
    IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'CompetitionId', N'CategoryId', N'Description', N'EventId', N'Name') AND [object_id] = OBJECT_ID(N'[Competitions]'))
        SET IDENTITY_INSERT [Competitions] ON;
    EXEC(N'INSERT INTO [Competitions] ([CompetitionId], [CategoryId], [Description], [EventId], [Name])
    VALUES (''ed523b48-77ed-414c-b954-4e9e55c0ccfa'', ''2724af1d-aa58-4c82-bcf2-7bd944038da4'', NULL, ''e21d0e2d-f692-4e4a-a421-d7f8bcb06fef'', N''Folk Dance'')');
    IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'CompetitionId', N'CategoryId', N'Description', N'EventId', N'Name') AND [object_id] = OBJECT_ID(N'[Competitions]'))
        SET IDENTITY_INSERT [Competitions] OFF;
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231127172649_Initial')
BEGIN
    IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'ContestantId', N'CompetitionId', N'EventId', N'FirstName', N'LastName', N'TeamId') AND [object_id] = OBJECT_ID(N'[Contestants]'))
        SET IDENTITY_INSERT [Contestants] ON;
    EXEC(N'INSERT INTO [Contestants] ([ContestantId], [CompetitionId], [EventId], [FirstName], [LastName], [TeamId])
    VALUES (''175da00f-de0a-4171-891e-36e0847a3026'', ''3be3d386-365a-4563-8a8f-233cb2ddafef'', ''e21d0e2d-f692-4e4a-a421-d7f8bcb06fef'', N''Danica'', N''Tejano'', ''49ef35ab-a315-4858-ad1c-ba4aa9777c56'')');
    IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'ContestantId', N'CompetitionId', N'EventId', N'FirstName', N'LastName', N'TeamId') AND [object_id] = OBJECT_ID(N'[Contestants]'))
        SET IDENTITY_INSERT [Contestants] OFF;
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231127172649_Initial')
BEGIN
    IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'ContestantId', N'CompetitionId', N'EventId', N'FirstName', N'LastName', N'TeamId') AND [object_id] = OBJECT_ID(N'[Contestants]'))
        SET IDENTITY_INSERT [Contestants] ON;
    EXEC(N'INSERT INTO [Contestants] ([ContestantId], [CompetitionId], [EventId], [FirstName], [LastName], [TeamId])
    VALUES (''5f70d17d-d6e0-40e7-a8a2-02460ba91ec0'', ''ed523b48-77ed-414c-b954-4e9e55c0ccfa'', ''e21d0e2d-f692-4e4a-a421-d7f8bcb06fef'', N''Mikael'', N''Aggarao'', ''49ef35ab-a315-4858-ad1c-ba4aa9777c56'')');
    IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'ContestantId', N'CompetitionId', N'EventId', N'FirstName', N'LastName', N'TeamId') AND [object_id] = OBJECT_ID(N'[Contestants]'))
        SET IDENTITY_INSERT [Contestants] OFF;
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231127172649_Initial')
BEGIN
    CREATE INDEX [IX_ApplicationUserCompetition_JudgesId] ON [ApplicationUserCompetition] ([JudgesId]);
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231127172649_Initial')
BEGIN
    CREATE INDEX [IX_AspNetRoleClaims_RoleId] ON [AspNetRoleClaims] ([RoleId]);
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231127172649_Initial')
BEGIN
    EXEC(N'CREATE UNIQUE INDEX [RoleNameIndex] ON [AspNetRoles] ([NormalizedName]) WHERE [NormalizedName] IS NOT NULL');
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231127172649_Initial')
BEGIN
    CREATE INDEX [IX_AspNetUserClaims_UserId] ON [AspNetUserClaims] ([UserId]);
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231127172649_Initial')
BEGIN
    CREATE INDEX [IX_AspNetUserLogins_UserId] ON [AspNetUserLogins] ([UserId]);
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231127172649_Initial')
BEGIN
    CREATE INDEX [IX_AspNetUserRoles_RoleId] ON [AspNetUserRoles] ([RoleId]);
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231127172649_Initial')
BEGIN
    CREATE INDEX [EmailIndex] ON [AspNetUsers] ([NormalizedEmail]);
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231127172649_Initial')
BEGIN
    EXEC(N'CREATE UNIQUE INDEX [UserNameIndex] ON [AspNetUsers] ([NormalizedUserName]) WHERE [NormalizedUserName] IS NOT NULL');
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231127172649_Initial')
BEGIN
    CREATE INDEX [IX_Categories_EventId] ON [Categories] ([EventId]);
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231127172649_Initial')
BEGIN
    CREATE INDEX [IX_Competitions_CategoryId] ON [Competitions] ([CategoryId]);
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231127172649_Initial')
BEGIN
    CREATE INDEX [IX_Competitions_EventId] ON [Competitions] ([EventId]);
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231127172649_Initial')
BEGIN
    CREATE INDEX [IX_Contestants_CompetitionId] ON [Contestants] ([CompetitionId]);
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231127172649_Initial')
BEGIN
    CREATE INDEX [IX_Contestants_EventId] ON [Contestants] ([EventId]);
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231127172649_Initial')
BEGIN
    CREATE INDEX [IX_Contestants_TeamId] ON [Contestants] ([TeamId]);
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231127172649_Initial')
BEGIN
    CREATE INDEX [IX_Criteria_CompetitionId] ON [Criteria] ([CompetitionId]);
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231127172649_Initial')
BEGIN
    CREATE INDEX [IX_Events_ApplicationUserId] ON [Events] ([ApplicationUserId]);
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231127172649_Initial')
BEGIN
    CREATE UNIQUE INDEX [IX_Events_Url] ON [Events] ([Url]);
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231127172649_Initial')
BEGIN
    CREATE INDEX [IX_Scores_CriterionId] ON [Scores] ([CriterionId]);
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231127172649_Initial')
BEGIN
    CREATE INDEX [IX_Teams_EventId] ON [Teams] ([EventId]);
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231127172649_Initial')
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20231127172649_Initial', N'6.0.24');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231130160835_addScoresToApplicationUser')
BEGIN
    EXEC(N'DELETE FROM [Categories]
    WHERE [CategoryId] = ''51860641-f544-437a-a351-aefb8edb46d0'';
    SELECT @@ROWCOUNT');
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231130160835_addScoresToApplicationUser')
BEGIN
    EXEC(N'DELETE FROM [Contestants]
    WHERE [ContestantId] = ''175da00f-de0a-4171-891e-36e0847a3026'';
    SELECT @@ROWCOUNT');
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231130160835_addScoresToApplicationUser')
BEGIN
    EXEC(N'DELETE FROM [Contestants]
    WHERE [ContestantId] = ''5f70d17d-d6e0-40e7-a8a2-02460ba91ec0'';
    SELECT @@ROWCOUNT');
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231130160835_addScoresToApplicationUser')
BEGIN
    EXEC(N'DELETE FROM [Teams]
    WHERE [TeamId] = ''2c510245-4c0c-4d48-b242-f5303e7ea042'';
    SELECT @@ROWCOUNT');
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231130160835_addScoresToApplicationUser')
BEGIN
    EXEC(N'DELETE FROM [Teams]
    WHERE [TeamId] = ''7c9fe5c0-5733-4a9b-80b2-b8277c1dd01f'';
    SELECT @@ROWCOUNT');
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231130160835_addScoresToApplicationUser')
BEGIN
    EXEC(N'DELETE FROM [Teams]
    WHERE [TeamId] = ''c133c1b9-4727-4431-9281-acf11415dc34'';
    SELECT @@ROWCOUNT');
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231130160835_addScoresToApplicationUser')
BEGIN
    EXEC(N'DELETE FROM [Competitions]
    WHERE [CompetitionId] = ''3be3d386-365a-4563-8a8f-233cb2ddafef'';
    SELECT @@ROWCOUNT');
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231130160835_addScoresToApplicationUser')
BEGIN
    EXEC(N'DELETE FROM [Competitions]
    WHERE [CompetitionId] = ''ed523b48-77ed-414c-b954-4e9e55c0ccfa'';
    SELECT @@ROWCOUNT');
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231130160835_addScoresToApplicationUser')
BEGIN
    EXEC(N'DELETE FROM [Teams]
    WHERE [TeamId] = ''49ef35ab-a315-4858-ad1c-ba4aa9777c56'';
    SELECT @@ROWCOUNT');
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231130160835_addScoresToApplicationUser')
BEGIN
    EXEC(N'DELETE FROM [Categories]
    WHERE [CategoryId] = ''2724af1d-aa58-4c82-bcf2-7bd944038da4'';
    SELECT @@ROWCOUNT');
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231130160835_addScoresToApplicationUser')
BEGIN
    EXEC(N'DELETE FROM [Events]
    WHERE [EventId] = ''e21d0e2d-f692-4e4a-a421-d7f8bcb06fef'';
    SELECT @@ROWCOUNT');
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231130160835_addScoresToApplicationUser')
BEGIN
    EXEC(N'DELETE FROM [AspNetUsers]
    WHERE [Id] = N''0c1445ea-4bac-4682-b39a-3a4889c258d0'';
    SELECT @@ROWCOUNT');
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231130160835_addScoresToApplicationUser')
BEGIN
    ALTER TABLE [Scores] ADD [JudgeId] nvarchar(450) NULL;
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231130160835_addScoresToApplicationUser')
BEGIN
    IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'Id', N'AccessFailedCount', N'ConcurrencyStamp', N'Discriminator', N'Email', N'EmailConfirmed', N'FirstName', N'LastName', N'LockoutEnabled', N'LockoutEnd', N'NormalizedEmail', N'NormalizedUserName', N'PasswordHash', N'PhoneNumber', N'PhoneNumberConfirmed', N'SecurityStamp', N'TwoFactorEnabled', N'UserName') AND [object_id] = OBJECT_ID(N'[AspNetUsers]'))
        SET IDENTITY_INSERT [AspNetUsers] ON;
    EXEC(N'INSERT INTO [AspNetUsers] ([Id], [AccessFailedCount], [ConcurrencyStamp], [Discriminator], [Email], [EmailConfirmed], [FirstName], [LastName], [LockoutEnabled], [LockoutEnd], [NormalizedEmail], [NormalizedUserName], [PasswordHash], [PhoneNumber], [PhoneNumberConfirmed], [SecurityStamp], [TwoFactorEnabled], [UserName])
    VALUES (N''87011dfd-03b2-4c79-b09b-946e961373d9'', 0, N''8423c05d-00b5-420f-af84-9e2795f94abc'', N''ApplicationUser'', N''admindummy@gmail.com'', CAST(1 AS bit), N''Dummy'', N''Dummy'', CAST(0 AS bit), NULL, N''ADMINDUMMY@GMAIL.COM'', N''ADMINDUMMY@GMAIL.COM'', N''AQAAAAEAACcQAAAAECzad8Ob/oRO5EIIqU1JYz73Run/G5fsQQc2OqX9AMaFm+rcuOCylCZKCse+f5G5UA=='', N''09156390954'', CAST(1 AS bit), N''00000000-0000-0000-0000-000000000000'', CAST(0 AS bit), N''admindummy@gmail.com'')');
    IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'Id', N'AccessFailedCount', N'ConcurrencyStamp', N'Discriminator', N'Email', N'EmailConfirmed', N'FirstName', N'LastName', N'LockoutEnabled', N'LockoutEnd', N'NormalizedEmail', N'NormalizedUserName', N'PasswordHash', N'PhoneNumber', N'PhoneNumberConfirmed', N'SecurityStamp', N'TwoFactorEnabled', N'UserName') AND [object_id] = OBJECT_ID(N'[AspNetUsers]'))
        SET IDENTITY_INSERT [AspNetUsers] OFF;
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231130160835_addScoresToApplicationUser')
BEGIN
    IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'EventId', N'ApplicationUserId', N'EventEndDate', N'EventName', N'EventStartDate', N'Url') AND [object_id] = OBJECT_ID(N'[Events]'))
        SET IDENTITY_INSERT [Events] ON;
    EXEC(N'INSERT INTO [Events] ([EventId], [ApplicationUserId], [EventEndDate], [EventName], [EventStartDate], [Url])
    VALUES (''266f0efe-dd0b-4cfb-a0fe-f03b99027d94'', N''87011dfd-03b2-4c79-b09b-946e961373d9'', NULL, N''Foundation Week 2024 '', NULL, N''kukiDzzv'')');
    IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'EventId', N'ApplicationUserId', N'EventEndDate', N'EventName', N'EventStartDate', N'Url') AND [object_id] = OBJECT_ID(N'[Events]'))
        SET IDENTITY_INSERT [Events] OFF;
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231130160835_addScoresToApplicationUser')
BEGIN
    IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'CategoryId', N'EventId', N'Name') AND [object_id] = OBJECT_ID(N'[Categories]'))
        SET IDENTITY_INSERT [Categories] ON;
    EXEC(N'INSERT INTO [Categories] ([CategoryId], [EventId], [Name])
    VALUES (''7f1820ea-a51c-4c2a-ae12-d05a58576726'', ''266f0efe-dd0b-4cfb-a0fe-f03b99027d94'', N''Literary''),
    (''d1bd7230-bfc6-4d98-a333-2c05112d6b81'', ''266f0efe-dd0b-4cfb-a0fe-f03b99027d94'', N''Socio-Cultural'')');
    IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'CategoryId', N'EventId', N'Name') AND [object_id] = OBJECT_ID(N'[Categories]'))
        SET IDENTITY_INSERT [Categories] OFF;
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231130160835_addScoresToApplicationUser')
BEGIN
    IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'TeamId', N'Abbreviation', N'EventId', N'FullName') AND [object_id] = OBJECT_ID(N'[Teams]'))
        SET IDENTITY_INSERT [Teams] ON;
    EXEC(N'INSERT INTO [Teams] ([TeamId], [Abbreviation], [EventId], [FullName])
    VALUES (''25f955ac-c83c-4512-a597-89178ab7a01e'', N''SABH'', ''266f0efe-dd0b-4cfb-a0fe-f03b99027d94'', N''School of Accountancy, Business, and Hospitality''),
    (''389ed360-48da-4355-992e-b30b75bf50e6'', N''SEAITE'', ''266f0efe-dd0b-4cfb-a0fe-f03b99027d94'', N''School of Engineering Architecture and Information Technology Education''),
    (''45d91bf0-9518-4e84-b909-1736b106c3a4'', N''SEAS'', ''266f0efe-dd0b-4cfb-a0fe-f03b99027d94'', N''School of Education, Arts, and Sciences''),
    (''8c2b09f8-0b9f-4066-a538-b6b934b93dd4'', N''SHAS'', ''266f0efe-dd0b-4cfb-a0fe-f03b99027d94'', N''School of Health and Allied Sciences'')');
    IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'TeamId', N'Abbreviation', N'EventId', N'FullName') AND [object_id] = OBJECT_ID(N'[Teams]'))
        SET IDENTITY_INSERT [Teams] OFF;
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231130160835_addScoresToApplicationUser')
BEGIN
    IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'CompetitionId', N'CategoryId', N'Description', N'EventId', N'Name') AND [object_id] = OBJECT_ID(N'[Competitions]'))
        SET IDENTITY_INSERT [Competitions] ON;
    EXEC(N'INSERT INTO [Competitions] ([CompetitionId], [CategoryId], [Description], [EventId], [Name])
    VALUES (''89506a67-74c2-4db5-ae45-fbcb591f9e52'', ''d1bd7230-bfc6-4d98-a333-2c05112d6b81'', NULL, ''266f0efe-dd0b-4cfb-a0fe-f03b99027d94'', N''Folk Dance'')');
    IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'CompetitionId', N'CategoryId', N'Description', N'EventId', N'Name') AND [object_id] = OBJECT_ID(N'[Competitions]'))
        SET IDENTITY_INSERT [Competitions] OFF;
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231130160835_addScoresToApplicationUser')
BEGIN
    IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'CompetitionId', N'CategoryId', N'Description', N'EventId', N'Name') AND [object_id] = OBJECT_ID(N'[Competitions]'))
        SET IDENTITY_INSERT [Competitions] ON;
    EXEC(N'INSERT INTO [Competitions] ([CompetitionId], [CategoryId], [Description], [EventId], [Name])
    VALUES (''be945a55-7698-4146-8900-ee538af8c17e'', ''d1bd7230-bfc6-4d98-a333-2c05112d6b81'', NULL, ''266f0efe-dd0b-4cfb-a0fe-f03b99027d94'', N''Hiphop'')');
    IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'CompetitionId', N'CategoryId', N'Description', N'EventId', N'Name') AND [object_id] = OBJECT_ID(N'[Competitions]'))
        SET IDENTITY_INSERT [Competitions] OFF;
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231130160835_addScoresToApplicationUser')
BEGIN
    IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'ContestantId', N'CompetitionId', N'EventId', N'FirstName', N'LastName', N'TeamId') AND [object_id] = OBJECT_ID(N'[Contestants]'))
        SET IDENTITY_INSERT [Contestants] ON;
    EXEC(N'INSERT INTO [Contestants] ([ContestantId], [CompetitionId], [EventId], [FirstName], [LastName], [TeamId])
    VALUES (''12b77973-3839-4831-80b3-9ae3d8dce2c5'', ''be945a55-7698-4146-8900-ee538af8c17e'', ''266f0efe-dd0b-4cfb-a0fe-f03b99027d94'', N''Danica'', N''Tejano'', ''389ed360-48da-4355-992e-b30b75bf50e6'')');
    IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'ContestantId', N'CompetitionId', N'EventId', N'FirstName', N'LastName', N'TeamId') AND [object_id] = OBJECT_ID(N'[Contestants]'))
        SET IDENTITY_INSERT [Contestants] OFF;
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231130160835_addScoresToApplicationUser')
BEGIN
    IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'ContestantId', N'CompetitionId', N'EventId', N'FirstName', N'LastName', N'TeamId') AND [object_id] = OBJECT_ID(N'[Contestants]'))
        SET IDENTITY_INSERT [Contestants] ON;
    EXEC(N'INSERT INTO [Contestants] ([ContestantId], [CompetitionId], [EventId], [FirstName], [LastName], [TeamId])
    VALUES (''ea80d46f-4454-40b5-874c-e96751f909ac'', ''89506a67-74c2-4db5-ae45-fbcb591f9e52'', ''266f0efe-dd0b-4cfb-a0fe-f03b99027d94'', N''Mikael'', N''Aggarao'', ''389ed360-48da-4355-992e-b30b75bf50e6'')');
    IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'ContestantId', N'CompetitionId', N'EventId', N'FirstName', N'LastName', N'TeamId') AND [object_id] = OBJECT_ID(N'[Contestants]'))
        SET IDENTITY_INSERT [Contestants] OFF;
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231130160835_addScoresToApplicationUser')
BEGIN
    CREATE INDEX [IX_Scores_JudgeId] ON [Scores] ([JudgeId]);
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231130160835_addScoresToApplicationUser')
BEGIN
    ALTER TABLE [Scores] ADD CONSTRAINT [FK_Scores_AspNetUsers_JudgeId] FOREIGN KEY ([JudgeId]) REFERENCES [AspNetUsers] ([Id]);
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231130160835_addScoresToApplicationUser')
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20231130160835_addScoresToApplicationUser', N'6.0.24');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231201045019_addContestantIdToScoreTable')
BEGIN
    EXEC(N'DELETE FROM [Categories]
    WHERE [CategoryId] = ''7f1820ea-a51c-4c2a-ae12-d05a58576726'';
    SELECT @@ROWCOUNT');
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231201045019_addContestantIdToScoreTable')
BEGIN
    EXEC(N'DELETE FROM [Contestants]
    WHERE [ContestantId] = ''12b77973-3839-4831-80b3-9ae3d8dce2c5'';
    SELECT @@ROWCOUNT');
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231201045019_addContestantIdToScoreTable')
BEGIN
    EXEC(N'DELETE FROM [Contestants]
    WHERE [ContestantId] = ''ea80d46f-4454-40b5-874c-e96751f909ac'';
    SELECT @@ROWCOUNT');
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231201045019_addContestantIdToScoreTable')
BEGIN
    EXEC(N'DELETE FROM [Teams]
    WHERE [TeamId] = ''25f955ac-c83c-4512-a597-89178ab7a01e'';
    SELECT @@ROWCOUNT');
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231201045019_addContestantIdToScoreTable')
BEGIN
    EXEC(N'DELETE FROM [Teams]
    WHERE [TeamId] = ''45d91bf0-9518-4e84-b909-1736b106c3a4'';
    SELECT @@ROWCOUNT');
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231201045019_addContestantIdToScoreTable')
BEGIN
    EXEC(N'DELETE FROM [Teams]
    WHERE [TeamId] = ''8c2b09f8-0b9f-4066-a538-b6b934b93dd4'';
    SELECT @@ROWCOUNT');
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231201045019_addContestantIdToScoreTable')
BEGIN
    EXEC(N'DELETE FROM [Competitions]
    WHERE [CompetitionId] = ''89506a67-74c2-4db5-ae45-fbcb591f9e52'';
    SELECT @@ROWCOUNT');
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231201045019_addContestantIdToScoreTable')
BEGIN
    EXEC(N'DELETE FROM [Competitions]
    WHERE [CompetitionId] = ''be945a55-7698-4146-8900-ee538af8c17e'';
    SELECT @@ROWCOUNT');
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231201045019_addContestantIdToScoreTable')
BEGIN
    EXEC(N'DELETE FROM [Teams]
    WHERE [TeamId] = ''389ed360-48da-4355-992e-b30b75bf50e6'';
    SELECT @@ROWCOUNT');
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231201045019_addContestantIdToScoreTable')
BEGIN
    EXEC(N'DELETE FROM [Categories]
    WHERE [CategoryId] = ''d1bd7230-bfc6-4d98-a333-2c05112d6b81'';
    SELECT @@ROWCOUNT');
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231201045019_addContestantIdToScoreTable')
BEGIN
    EXEC(N'DELETE FROM [Events]
    WHERE [EventId] = ''266f0efe-dd0b-4cfb-a0fe-f03b99027d94'';
    SELECT @@ROWCOUNT');
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231201045019_addContestantIdToScoreTable')
BEGIN
    EXEC(N'DELETE FROM [AspNetUsers]
    WHERE [Id] = N''87011dfd-03b2-4c79-b09b-946e961373d9'';
    SELECT @@ROWCOUNT');
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231201045019_addContestantIdToScoreTable')
BEGIN
    ALTER TABLE [Scores] ADD [ContestantId] uniqueidentifier NULL;
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231201045019_addContestantIdToScoreTable')
BEGIN
    IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'Id', N'AccessFailedCount', N'ConcurrencyStamp', N'Discriminator', N'Email', N'EmailConfirmed', N'FirstName', N'LastName', N'LockoutEnabled', N'LockoutEnd', N'NormalizedEmail', N'NormalizedUserName', N'PasswordHash', N'PhoneNumber', N'PhoneNumberConfirmed', N'SecurityStamp', N'TwoFactorEnabled', N'UserName') AND [object_id] = OBJECT_ID(N'[AspNetUsers]'))
        SET IDENTITY_INSERT [AspNetUsers] ON;
    EXEC(N'INSERT INTO [AspNetUsers] ([Id], [AccessFailedCount], [ConcurrencyStamp], [Discriminator], [Email], [EmailConfirmed], [FirstName], [LastName], [LockoutEnabled], [LockoutEnd], [NormalizedEmail], [NormalizedUserName], [PasswordHash], [PhoneNumber], [PhoneNumberConfirmed], [SecurityStamp], [TwoFactorEnabled], [UserName])
    VALUES (N''6488b2c2-463b-4465-898e-7d3aa10b77aa'', 0, N''4762ed2d-29a2-4ead-8be1-349aaf0ed992'', N''ApplicationUser'', N''admindummy@gmail.com'', CAST(1 AS bit), N''Dummy'', N''Dummy'', CAST(0 AS bit), NULL, N''ADMINDUMMY@GMAIL.COM'', N''ADMINDUMMY@GMAIL.COM'', N''AQAAAAEAACcQAAAAEBUl83DWy0Zft7Dxq3O3aNKXOAjK8Yh7Vb05we+ju88OTjGyA7xmWZ43XX8fM20ugw=='', N''09156390954'', CAST(1 AS bit), N''00000000-0000-0000-0000-000000000000'', CAST(0 AS bit), N''admindummy@gmail.com'')');
    IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'Id', N'AccessFailedCount', N'ConcurrencyStamp', N'Discriminator', N'Email', N'EmailConfirmed', N'FirstName', N'LastName', N'LockoutEnabled', N'LockoutEnd', N'NormalizedEmail', N'NormalizedUserName', N'PasswordHash', N'PhoneNumber', N'PhoneNumberConfirmed', N'SecurityStamp', N'TwoFactorEnabled', N'UserName') AND [object_id] = OBJECT_ID(N'[AspNetUsers]'))
        SET IDENTITY_INSERT [AspNetUsers] OFF;
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231201045019_addContestantIdToScoreTable')
BEGIN
    IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'EventId', N'ApplicationUserId', N'EventEndDate', N'EventName', N'EventStartDate', N'Url') AND [object_id] = OBJECT_ID(N'[Events]'))
        SET IDENTITY_INSERT [Events] ON;
    EXEC(N'INSERT INTO [Events] ([EventId], [ApplicationUserId], [EventEndDate], [EventName], [EventStartDate], [Url])
    VALUES (''8c9b74ea-9a83-4dbd-be45-adebcbc2f10c'', N''6488b2c2-463b-4465-898e-7d3aa10b77aa'', NULL, N''Foundation Week 2024 '', NULL, N''QYpLPiDi'')');
    IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'EventId', N'ApplicationUserId', N'EventEndDate', N'EventName', N'EventStartDate', N'Url') AND [object_id] = OBJECT_ID(N'[Events]'))
        SET IDENTITY_INSERT [Events] OFF;
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231201045019_addContestantIdToScoreTable')
BEGIN
    IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'CategoryId', N'EventId', N'Name') AND [object_id] = OBJECT_ID(N'[Categories]'))
        SET IDENTITY_INSERT [Categories] ON;
    EXEC(N'INSERT INTO [Categories] ([CategoryId], [EventId], [Name])
    VALUES (''4f7e416e-ed4b-48b0-8849-71496a838ead'', ''8c9b74ea-9a83-4dbd-be45-adebcbc2f10c'', N''Literary''),
    (''d5683667-c1f8-4089-82d6-a9935f7dea60'', ''8c9b74ea-9a83-4dbd-be45-adebcbc2f10c'', N''Socio-Cultural'')');
    IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'CategoryId', N'EventId', N'Name') AND [object_id] = OBJECT_ID(N'[Categories]'))
        SET IDENTITY_INSERT [Categories] OFF;
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231201045019_addContestantIdToScoreTable')
BEGIN
    IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'TeamId', N'Abbreviation', N'EventId', N'FullName') AND [object_id] = OBJECT_ID(N'[Teams]'))
        SET IDENTITY_INSERT [Teams] ON;
    EXEC(N'INSERT INTO [Teams] ([TeamId], [Abbreviation], [EventId], [FullName])
    VALUES (''2014b7a9-658b-4914-b43a-974b77f638d5'', N''SHAS'', ''8c9b74ea-9a83-4dbd-be45-adebcbc2f10c'', N''School of Health and Allied Sciences''),
    (''5cc8b043-3fbc-4580-be51-c13cc86e23a7'', N''SABH'', ''8c9b74ea-9a83-4dbd-be45-adebcbc2f10c'', N''School of Accountancy, Business, and Hospitality''),
    (''b3cc83a5-ccc9-48fd-b671-3c554f790047'', N''SEAITE'', ''8c9b74ea-9a83-4dbd-be45-adebcbc2f10c'', N''School of Engineering Architecture and Information Technology Education''),
    (''b9c96128-1066-44a6-af0b-410306cc8464'', N''SEAS'', ''8c9b74ea-9a83-4dbd-be45-adebcbc2f10c'', N''School of Education, Arts, and Sciences'')');
    IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'TeamId', N'Abbreviation', N'EventId', N'FullName') AND [object_id] = OBJECT_ID(N'[Teams]'))
        SET IDENTITY_INSERT [Teams] OFF;
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231201045019_addContestantIdToScoreTable')
BEGIN
    IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'CompetitionId', N'CategoryId', N'Description', N'EventId', N'Name') AND [object_id] = OBJECT_ID(N'[Competitions]'))
        SET IDENTITY_INSERT [Competitions] ON;
    EXEC(N'INSERT INTO [Competitions] ([CompetitionId], [CategoryId], [Description], [EventId], [Name])
    VALUES (''385746af-f8ff-4942-9432-44a5902b6e2c'', ''d5683667-c1f8-4089-82d6-a9935f7dea60'', NULL, ''8c9b74ea-9a83-4dbd-be45-adebcbc2f10c'', N''Folk Dance'')');
    IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'CompetitionId', N'CategoryId', N'Description', N'EventId', N'Name') AND [object_id] = OBJECT_ID(N'[Competitions]'))
        SET IDENTITY_INSERT [Competitions] OFF;
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231201045019_addContestantIdToScoreTable')
BEGIN
    IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'CompetitionId', N'CategoryId', N'Description', N'EventId', N'Name') AND [object_id] = OBJECT_ID(N'[Competitions]'))
        SET IDENTITY_INSERT [Competitions] ON;
    EXEC(N'INSERT INTO [Competitions] ([CompetitionId], [CategoryId], [Description], [EventId], [Name])
    VALUES (''9a93186a-8b22-422c-a5e2-4172918aab8f'', ''d5683667-c1f8-4089-82d6-a9935f7dea60'', NULL, ''8c9b74ea-9a83-4dbd-be45-adebcbc2f10c'', N''Hiphop'')');
    IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'CompetitionId', N'CategoryId', N'Description', N'EventId', N'Name') AND [object_id] = OBJECT_ID(N'[Competitions]'))
        SET IDENTITY_INSERT [Competitions] OFF;
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231201045019_addContestantIdToScoreTable')
BEGIN
    IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'ContestantId', N'CompetitionId', N'EventId', N'FirstName', N'LastName', N'TeamId') AND [object_id] = OBJECT_ID(N'[Contestants]'))
        SET IDENTITY_INSERT [Contestants] ON;
    EXEC(N'INSERT INTO [Contestants] ([ContestantId], [CompetitionId], [EventId], [FirstName], [LastName], [TeamId])
    VALUES (''b53f6bd7-2faa-4176-b876-9e7e4f49ceae'', ''385746af-f8ff-4942-9432-44a5902b6e2c'', ''8c9b74ea-9a83-4dbd-be45-adebcbc2f10c'', N''Mikael'', N''Aggarao'', ''b3cc83a5-ccc9-48fd-b671-3c554f790047'')');
    IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'ContestantId', N'CompetitionId', N'EventId', N'FirstName', N'LastName', N'TeamId') AND [object_id] = OBJECT_ID(N'[Contestants]'))
        SET IDENTITY_INSERT [Contestants] OFF;
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231201045019_addContestantIdToScoreTable')
BEGIN
    IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'ContestantId', N'CompetitionId', N'EventId', N'FirstName', N'LastName', N'TeamId') AND [object_id] = OBJECT_ID(N'[Contestants]'))
        SET IDENTITY_INSERT [Contestants] ON;
    EXEC(N'INSERT INTO [Contestants] ([ContestantId], [CompetitionId], [EventId], [FirstName], [LastName], [TeamId])
    VALUES (''baec3ac5-b0c0-457c-acd7-8be8c343ad0c'', ''9a93186a-8b22-422c-a5e2-4172918aab8f'', ''8c9b74ea-9a83-4dbd-be45-adebcbc2f10c'', N''Danica'', N''Tejano'', ''b3cc83a5-ccc9-48fd-b671-3c554f790047'')');
    IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'ContestantId', N'CompetitionId', N'EventId', N'FirstName', N'LastName', N'TeamId') AND [object_id] = OBJECT_ID(N'[Contestants]'))
        SET IDENTITY_INSERT [Contestants] OFF;
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231201045019_addContestantIdToScoreTable')
BEGIN
    CREATE INDEX [IX_Scores_ContestantId] ON [Scores] ([ContestantId]);
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231201045019_addContestantIdToScoreTable')
BEGIN
    ALTER TABLE [Scores] ADD CONSTRAINT [FK_Scores_Contestants_ContestantId] FOREIGN KEY ([ContestantId]) REFERENCES [Contestants] ([ContestantId]);
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231201045019_addContestantIdToScoreTable')
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20231201045019_addContestantIdToScoreTable', N'6.0.24');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231202150139_addIsCompletedToContestant')
BEGIN
    EXEC(N'DELETE FROM [Categories]
    WHERE [CategoryId] = ''4f7e416e-ed4b-48b0-8849-71496a838ead'';
    SELECT @@ROWCOUNT');
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231202150139_addIsCompletedToContestant')
BEGIN
    EXEC(N'DELETE FROM [Contestants]
    WHERE [ContestantId] = ''b53f6bd7-2faa-4176-b876-9e7e4f49ceae'';
    SELECT @@ROWCOUNT');
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231202150139_addIsCompletedToContestant')
BEGIN
    EXEC(N'DELETE FROM [Contestants]
    WHERE [ContestantId] = ''baec3ac5-b0c0-457c-acd7-8be8c343ad0c'';
    SELECT @@ROWCOUNT');
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231202150139_addIsCompletedToContestant')
BEGIN
    EXEC(N'DELETE FROM [Teams]
    WHERE [TeamId] = ''2014b7a9-658b-4914-b43a-974b77f638d5'';
    SELECT @@ROWCOUNT');
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231202150139_addIsCompletedToContestant')
BEGIN
    EXEC(N'DELETE FROM [Teams]
    WHERE [TeamId] = ''5cc8b043-3fbc-4580-be51-c13cc86e23a7'';
    SELECT @@ROWCOUNT');
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231202150139_addIsCompletedToContestant')
BEGIN
    EXEC(N'DELETE FROM [Teams]
    WHERE [TeamId] = ''b9c96128-1066-44a6-af0b-410306cc8464'';
    SELECT @@ROWCOUNT');
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231202150139_addIsCompletedToContestant')
BEGIN
    EXEC(N'DELETE FROM [Competitions]
    WHERE [CompetitionId] = ''385746af-f8ff-4942-9432-44a5902b6e2c'';
    SELECT @@ROWCOUNT');
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231202150139_addIsCompletedToContestant')
BEGIN
    EXEC(N'DELETE FROM [Competitions]
    WHERE [CompetitionId] = ''9a93186a-8b22-422c-a5e2-4172918aab8f'';
    SELECT @@ROWCOUNT');
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231202150139_addIsCompletedToContestant')
BEGIN
    EXEC(N'DELETE FROM [Teams]
    WHERE [TeamId] = ''b3cc83a5-ccc9-48fd-b671-3c554f790047'';
    SELECT @@ROWCOUNT');
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231202150139_addIsCompletedToContestant')
BEGIN
    EXEC(N'DELETE FROM [Categories]
    WHERE [CategoryId] = ''d5683667-c1f8-4089-82d6-a9935f7dea60'';
    SELECT @@ROWCOUNT');
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231202150139_addIsCompletedToContestant')
BEGIN
    EXEC(N'DELETE FROM [Events]
    WHERE [EventId] = ''8c9b74ea-9a83-4dbd-be45-adebcbc2f10c'';
    SELECT @@ROWCOUNT');
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231202150139_addIsCompletedToContestant')
BEGIN
    EXEC(N'DELETE FROM [AspNetUsers]
    WHERE [Id] = N''6488b2c2-463b-4465-898e-7d3aa10b77aa'';
    SELECT @@ROWCOUNT');
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231202150139_addIsCompletedToContestant')
BEGIN
    IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'Id', N'AccessFailedCount', N'ConcurrencyStamp', N'Discriminator', N'Email', N'EmailConfirmed', N'FirstName', N'LastName', N'LockoutEnabled', N'LockoutEnd', N'NormalizedEmail', N'NormalizedUserName', N'PasswordHash', N'PhoneNumber', N'PhoneNumberConfirmed', N'SecurityStamp', N'TwoFactorEnabled', N'UserName') AND [object_id] = OBJECT_ID(N'[AspNetUsers]'))
        SET IDENTITY_INSERT [AspNetUsers] ON;
    EXEC(N'INSERT INTO [AspNetUsers] ([Id], [AccessFailedCount], [ConcurrencyStamp], [Discriminator], [Email], [EmailConfirmed], [FirstName], [LastName], [LockoutEnabled], [LockoutEnd], [NormalizedEmail], [NormalizedUserName], [PasswordHash], [PhoneNumber], [PhoneNumberConfirmed], [SecurityStamp], [TwoFactorEnabled], [UserName])
    VALUES (N''aa7cbc16-5322-49c4-95e6-72e1c240a634'', 0, N''c47b5fcf-0faf-4de1-91bb-9ed9dc31849c'', N''ApplicationUser'', N''admindummy@gmail.com'', CAST(1 AS bit), N''Dummy'', N''Dummy'', CAST(0 AS bit), NULL, N''ADMINDUMMY@GMAIL.COM'', N''ADMINDUMMY@GMAIL.COM'', N''AQAAAAEAACcQAAAAEJTcxhkhkfad9Te5UZTxo4ofAFYRi8maeX6n1KS8XFwAaDteeFO5zWu/vhHbPLWqxQ=='', N''09156390954'', CAST(1 AS bit), N''00000000-0000-0000-0000-000000000000'', CAST(0 AS bit), N''admindummy@gmail.com'')');
    IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'Id', N'AccessFailedCount', N'ConcurrencyStamp', N'Discriminator', N'Email', N'EmailConfirmed', N'FirstName', N'LastName', N'LockoutEnabled', N'LockoutEnd', N'NormalizedEmail', N'NormalizedUserName', N'PasswordHash', N'PhoneNumber', N'PhoneNumberConfirmed', N'SecurityStamp', N'TwoFactorEnabled', N'UserName') AND [object_id] = OBJECT_ID(N'[AspNetUsers]'))
        SET IDENTITY_INSERT [AspNetUsers] OFF;
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231202150139_addIsCompletedToContestant')
BEGIN
    IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'EventId', N'ApplicationUserId', N'EventEndDate', N'EventName', N'EventStartDate', N'Url') AND [object_id] = OBJECT_ID(N'[Events]'))
        SET IDENTITY_INSERT [Events] ON;
    EXEC(N'INSERT INTO [Events] ([EventId], [ApplicationUserId], [EventEndDate], [EventName], [EventStartDate], [Url])
    VALUES (''bf61aa5e-50a2-4970-b6d2-885837ff7d74'', N''aa7cbc16-5322-49c4-95e6-72e1c240a634'', NULL, N''Foundation Week 2024 '', NULL, N''fQZPwypb'')');
    IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'EventId', N'ApplicationUserId', N'EventEndDate', N'EventName', N'EventStartDate', N'Url') AND [object_id] = OBJECT_ID(N'[Events]'))
        SET IDENTITY_INSERT [Events] OFF;
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231202150139_addIsCompletedToContestant')
BEGIN
    IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'CategoryId', N'EventId', N'Name') AND [object_id] = OBJECT_ID(N'[Categories]'))
        SET IDENTITY_INSERT [Categories] ON;
    EXEC(N'INSERT INTO [Categories] ([CategoryId], [EventId], [Name])
    VALUES (''c3f21b51-8c18-4976-bbdf-087a015ecb4c'', ''bf61aa5e-50a2-4970-b6d2-885837ff7d74'', N''Literary''),
    (''d0fa9aba-c093-4c2a-bcdc-f9a5cf15ca33'', ''bf61aa5e-50a2-4970-b6d2-885837ff7d74'', N''Socio-Cultural'')');
    IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'CategoryId', N'EventId', N'Name') AND [object_id] = OBJECT_ID(N'[Categories]'))
        SET IDENTITY_INSERT [Categories] OFF;
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231202150139_addIsCompletedToContestant')
BEGIN
    IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'TeamId', N'Abbreviation', N'EventId', N'FullName') AND [object_id] = OBJECT_ID(N'[Teams]'))
        SET IDENTITY_INSERT [Teams] ON;
    EXEC(N'INSERT INTO [Teams] ([TeamId], [Abbreviation], [EventId], [FullName])
    VALUES (''847d38b9-69ab-4bdc-825b-361ffe46e8e4'', N''SABH'', ''bf61aa5e-50a2-4970-b6d2-885837ff7d74'', N''School of Accountancy, Business, and Hospitality''),
    (''96503ae6-a96a-4c4b-b072-5937479db94c'', N''SEAS'', ''bf61aa5e-50a2-4970-b6d2-885837ff7d74'', N''School of Education, Arts, and Sciences''),
    (''d0bb88d9-1f3d-4d8c-b817-6916e2351d60'', N''SEAITE'', ''bf61aa5e-50a2-4970-b6d2-885837ff7d74'', N''School of Engineering Architecture and Information Technology Education''),
    (''db8a3a85-b4cf-45ac-9e00-f89f5434eedf'', N''SHAS'', ''bf61aa5e-50a2-4970-b6d2-885837ff7d74'', N''School of Health and Allied Sciences'')');
    IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'TeamId', N'Abbreviation', N'EventId', N'FullName') AND [object_id] = OBJECT_ID(N'[Teams]'))
        SET IDENTITY_INSERT [Teams] OFF;
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231202150139_addIsCompletedToContestant')
BEGIN
    IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'CompetitionId', N'CategoryId', N'Description', N'EventId', N'Name') AND [object_id] = OBJECT_ID(N'[Competitions]'))
        SET IDENTITY_INSERT [Competitions] ON;
    EXEC(N'INSERT INTO [Competitions] ([CompetitionId], [CategoryId], [Description], [EventId], [Name])
    VALUES (''59a1bb6c-1344-49f8-a5ff-31521de3656e'', ''d0fa9aba-c093-4c2a-bcdc-f9a5cf15ca33'', NULL, ''bf61aa5e-50a2-4970-b6d2-885837ff7d74'', N''Folk Dance'')');
    IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'CompetitionId', N'CategoryId', N'Description', N'EventId', N'Name') AND [object_id] = OBJECT_ID(N'[Competitions]'))
        SET IDENTITY_INSERT [Competitions] OFF;
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231202150139_addIsCompletedToContestant')
BEGIN
    IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'CompetitionId', N'CategoryId', N'Description', N'EventId', N'Name') AND [object_id] = OBJECT_ID(N'[Competitions]'))
        SET IDENTITY_INSERT [Competitions] ON;
    EXEC(N'INSERT INTO [Competitions] ([CompetitionId], [CategoryId], [Description], [EventId], [Name])
    VALUES (''a62b7d91-7035-491f-ba29-d001b0a371ea'', ''d0fa9aba-c093-4c2a-bcdc-f9a5cf15ca33'', NULL, ''bf61aa5e-50a2-4970-b6d2-885837ff7d74'', N''Hiphop'')');
    IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'CompetitionId', N'CategoryId', N'Description', N'EventId', N'Name') AND [object_id] = OBJECT_ID(N'[Competitions]'))
        SET IDENTITY_INSERT [Competitions] OFF;
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231202150139_addIsCompletedToContestant')
BEGIN
    IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'ContestantId', N'CompetitionId', N'EventId', N'FirstName', N'LastName', N'TeamId') AND [object_id] = OBJECT_ID(N'[Contestants]'))
        SET IDENTITY_INSERT [Contestants] ON;
    EXEC(N'INSERT INTO [Contestants] ([ContestantId], [CompetitionId], [EventId], [FirstName], [LastName], [TeamId])
    VALUES (''2d4e7210-732e-45b2-bf44-df38fe15b1e3'', ''a62b7d91-7035-491f-ba29-d001b0a371ea'', ''bf61aa5e-50a2-4970-b6d2-885837ff7d74'', N''Danica'', N''Tejano'', ''d0bb88d9-1f3d-4d8c-b817-6916e2351d60'')');
    IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'ContestantId', N'CompetitionId', N'EventId', N'FirstName', N'LastName', N'TeamId') AND [object_id] = OBJECT_ID(N'[Contestants]'))
        SET IDENTITY_INSERT [Contestants] OFF;
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231202150139_addIsCompletedToContestant')
BEGIN
    IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'ContestantId', N'CompetitionId', N'EventId', N'FirstName', N'LastName', N'TeamId') AND [object_id] = OBJECT_ID(N'[Contestants]'))
        SET IDENTITY_INSERT [Contestants] ON;
    EXEC(N'INSERT INTO [Contestants] ([ContestantId], [CompetitionId], [EventId], [FirstName], [LastName], [TeamId])
    VALUES (''79164add-5074-4e21-93d3-c60a6cd22aeb'', ''59a1bb6c-1344-49f8-a5ff-31521de3656e'', ''bf61aa5e-50a2-4970-b6d2-885837ff7d74'', N''Mikael'', N''Aggarao'', ''d0bb88d9-1f3d-4d8c-b817-6916e2351d60'')');
    IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'ContestantId', N'CompetitionId', N'EventId', N'FirstName', N'LastName', N'TeamId') AND [object_id] = OBJECT_ID(N'[Contestants]'))
        SET IDENTITY_INSERT [Contestants] OFF;
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231202150139_addIsCompletedToContestant')
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20231202150139_addIsCompletedToContestant', N'6.0.24');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231202150644_addIsCompletedAndAverageScoreToContestant')
BEGIN
    EXEC(N'DELETE FROM [Categories]
    WHERE [CategoryId] = ''c3f21b51-8c18-4976-bbdf-087a015ecb4c'';
    SELECT @@ROWCOUNT');
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231202150644_addIsCompletedAndAverageScoreToContestant')
BEGIN
    EXEC(N'DELETE FROM [Contestants]
    WHERE [ContestantId] = ''2d4e7210-732e-45b2-bf44-df38fe15b1e3'';
    SELECT @@ROWCOUNT');
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231202150644_addIsCompletedAndAverageScoreToContestant')
BEGIN
    EXEC(N'DELETE FROM [Contestants]
    WHERE [ContestantId] = ''79164add-5074-4e21-93d3-c60a6cd22aeb'';
    SELECT @@ROWCOUNT');
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231202150644_addIsCompletedAndAverageScoreToContestant')
BEGIN
    EXEC(N'DELETE FROM [Teams]
    WHERE [TeamId] = ''847d38b9-69ab-4bdc-825b-361ffe46e8e4'';
    SELECT @@ROWCOUNT');
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231202150644_addIsCompletedAndAverageScoreToContestant')
BEGIN
    EXEC(N'DELETE FROM [Teams]
    WHERE [TeamId] = ''96503ae6-a96a-4c4b-b072-5937479db94c'';
    SELECT @@ROWCOUNT');
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231202150644_addIsCompletedAndAverageScoreToContestant')
BEGIN
    EXEC(N'DELETE FROM [Teams]
    WHERE [TeamId] = ''db8a3a85-b4cf-45ac-9e00-f89f5434eedf'';
    SELECT @@ROWCOUNT');
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231202150644_addIsCompletedAndAverageScoreToContestant')
BEGIN
    EXEC(N'DELETE FROM [Competitions]
    WHERE [CompetitionId] = ''59a1bb6c-1344-49f8-a5ff-31521de3656e'';
    SELECT @@ROWCOUNT');
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231202150644_addIsCompletedAndAverageScoreToContestant')
BEGIN
    EXEC(N'DELETE FROM [Competitions]
    WHERE [CompetitionId] = ''a62b7d91-7035-491f-ba29-d001b0a371ea'';
    SELECT @@ROWCOUNT');
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231202150644_addIsCompletedAndAverageScoreToContestant')
BEGIN
    EXEC(N'DELETE FROM [Teams]
    WHERE [TeamId] = ''d0bb88d9-1f3d-4d8c-b817-6916e2351d60'';
    SELECT @@ROWCOUNT');
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231202150644_addIsCompletedAndAverageScoreToContestant')
BEGIN
    EXEC(N'DELETE FROM [Categories]
    WHERE [CategoryId] = ''d0fa9aba-c093-4c2a-bcdc-f9a5cf15ca33'';
    SELECT @@ROWCOUNT');
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231202150644_addIsCompletedAndAverageScoreToContestant')
BEGIN
    EXEC(N'DELETE FROM [Events]
    WHERE [EventId] = ''bf61aa5e-50a2-4970-b6d2-885837ff7d74'';
    SELECT @@ROWCOUNT');
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231202150644_addIsCompletedAndAverageScoreToContestant')
BEGIN
    EXEC(N'DELETE FROM [AspNetUsers]
    WHERE [Id] = N''aa7cbc16-5322-49c4-95e6-72e1c240a634'';
    SELECT @@ROWCOUNT');
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231202150644_addIsCompletedAndAverageScoreToContestant')
BEGIN
    ALTER TABLE [Contestants] ADD [AverageScore] decimal(18,2) NULL;
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231202150644_addIsCompletedAndAverageScoreToContestant')
BEGIN
    ALTER TABLE [Contestants] ADD [IsCompleted] bit NULL;
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231202150644_addIsCompletedAndAverageScoreToContestant')
BEGIN
    IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'Id', N'AccessFailedCount', N'ConcurrencyStamp', N'Discriminator', N'Email', N'EmailConfirmed', N'FirstName', N'LastName', N'LockoutEnabled', N'LockoutEnd', N'NormalizedEmail', N'NormalizedUserName', N'PasswordHash', N'PhoneNumber', N'PhoneNumberConfirmed', N'SecurityStamp', N'TwoFactorEnabled', N'UserName') AND [object_id] = OBJECT_ID(N'[AspNetUsers]'))
        SET IDENTITY_INSERT [AspNetUsers] ON;
    EXEC(N'INSERT INTO [AspNetUsers] ([Id], [AccessFailedCount], [ConcurrencyStamp], [Discriminator], [Email], [EmailConfirmed], [FirstName], [LastName], [LockoutEnabled], [LockoutEnd], [NormalizedEmail], [NormalizedUserName], [PasswordHash], [PhoneNumber], [PhoneNumberConfirmed], [SecurityStamp], [TwoFactorEnabled], [UserName])
    VALUES (N''a40d2b73-2bcd-41b9-ba85-793ce867daea'', 0, N''8d8d698f-1ca0-4f05-9c82-863a172be08c'', N''ApplicationUser'', N''admindummy@gmail.com'', CAST(1 AS bit), N''Dummy'', N''Dummy'', CAST(0 AS bit), NULL, N''ADMINDUMMY@GMAIL.COM'', N''ADMINDUMMY@GMAIL.COM'', N''AQAAAAEAACcQAAAAEIyMnYp3QWrTYmow2PE6T6/Y4B8rYhpNkcbnpfxg465frBuPzCmwvnORo0/77sruog=='', N''09156390954'', CAST(1 AS bit), N''00000000-0000-0000-0000-000000000000'', CAST(0 AS bit), N''admindummy@gmail.com'')');
    IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'Id', N'AccessFailedCount', N'ConcurrencyStamp', N'Discriminator', N'Email', N'EmailConfirmed', N'FirstName', N'LastName', N'LockoutEnabled', N'LockoutEnd', N'NormalizedEmail', N'NormalizedUserName', N'PasswordHash', N'PhoneNumber', N'PhoneNumberConfirmed', N'SecurityStamp', N'TwoFactorEnabled', N'UserName') AND [object_id] = OBJECT_ID(N'[AspNetUsers]'))
        SET IDENTITY_INSERT [AspNetUsers] OFF;
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231202150644_addIsCompletedAndAverageScoreToContestant')
BEGIN
    IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'EventId', N'ApplicationUserId', N'EventEndDate', N'EventName', N'EventStartDate', N'Url') AND [object_id] = OBJECT_ID(N'[Events]'))
        SET IDENTITY_INSERT [Events] ON;
    EXEC(N'INSERT INTO [Events] ([EventId], [ApplicationUserId], [EventEndDate], [EventName], [EventStartDate], [Url])
    VALUES (''1ac7207c-731e-4564-93a5-ebb5ada0c39c'', N''a40d2b73-2bcd-41b9-ba85-793ce867daea'', NULL, N''Foundation Week 2024 '', NULL, N''DnvYRAbo'')');
    IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'EventId', N'ApplicationUserId', N'EventEndDate', N'EventName', N'EventStartDate', N'Url') AND [object_id] = OBJECT_ID(N'[Events]'))
        SET IDENTITY_INSERT [Events] OFF;
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231202150644_addIsCompletedAndAverageScoreToContestant')
BEGIN
    IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'CategoryId', N'EventId', N'Name') AND [object_id] = OBJECT_ID(N'[Categories]'))
        SET IDENTITY_INSERT [Categories] ON;
    EXEC(N'INSERT INTO [Categories] ([CategoryId], [EventId], [Name])
    VALUES (''6e481171-0fcc-4794-b358-d030d277b4ae'', ''1ac7207c-731e-4564-93a5-ebb5ada0c39c'', N''Literary''),
    (''7cba0e3a-4ec2-487c-9134-abe65f974b72'', ''1ac7207c-731e-4564-93a5-ebb5ada0c39c'', N''Socio-Cultural'')');
    IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'CategoryId', N'EventId', N'Name') AND [object_id] = OBJECT_ID(N'[Categories]'))
        SET IDENTITY_INSERT [Categories] OFF;
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231202150644_addIsCompletedAndAverageScoreToContestant')
BEGIN
    IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'TeamId', N'Abbreviation', N'EventId', N'FullName') AND [object_id] = OBJECT_ID(N'[Teams]'))
        SET IDENTITY_INSERT [Teams] ON;
    EXEC(N'INSERT INTO [Teams] ([TeamId], [Abbreviation], [EventId], [FullName])
    VALUES (''21bbc6a7-9fe9-4fc9-8fa8-7f881b52c586'', N''SABH'', ''1ac7207c-731e-4564-93a5-ebb5ada0c39c'', N''School of Accountancy, Business, and Hospitality''),
    (''27f80cb6-2aea-42ae-9a5d-2a9cc6d2cc7d'', N''SEAITE'', ''1ac7207c-731e-4564-93a5-ebb5ada0c39c'', N''School of Engineering Architecture and Information Technology Education''),
    (''302849ce-4d9b-4d85-a378-61221ce9210b'', N''SEAS'', ''1ac7207c-731e-4564-93a5-ebb5ada0c39c'', N''School of Education, Arts, and Sciences''),
    (''bd0af02f-ce18-4d44-b553-101c1a7699da'', N''SHAS'', ''1ac7207c-731e-4564-93a5-ebb5ada0c39c'', N''School of Health and Allied Sciences'')');
    IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'TeamId', N'Abbreviation', N'EventId', N'FullName') AND [object_id] = OBJECT_ID(N'[Teams]'))
        SET IDENTITY_INSERT [Teams] OFF;
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231202150644_addIsCompletedAndAverageScoreToContestant')
BEGIN
    IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'CompetitionId', N'CategoryId', N'Description', N'EventId', N'Name') AND [object_id] = OBJECT_ID(N'[Competitions]'))
        SET IDENTITY_INSERT [Competitions] ON;
    EXEC(N'INSERT INTO [Competitions] ([CompetitionId], [CategoryId], [Description], [EventId], [Name])
    VALUES (''09100e83-cd04-4183-90de-2a47eb51ec82'', ''7cba0e3a-4ec2-487c-9134-abe65f974b72'', NULL, ''1ac7207c-731e-4564-93a5-ebb5ada0c39c'', N''Folk Dance'')');
    IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'CompetitionId', N'CategoryId', N'Description', N'EventId', N'Name') AND [object_id] = OBJECT_ID(N'[Competitions]'))
        SET IDENTITY_INSERT [Competitions] OFF;
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231202150644_addIsCompletedAndAverageScoreToContestant')
BEGIN
    IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'CompetitionId', N'CategoryId', N'Description', N'EventId', N'Name') AND [object_id] = OBJECT_ID(N'[Competitions]'))
        SET IDENTITY_INSERT [Competitions] ON;
    EXEC(N'INSERT INTO [Competitions] ([CompetitionId], [CategoryId], [Description], [EventId], [Name])
    VALUES (''a50f345f-0fec-4c26-ba56-ced71962e3c8'', ''7cba0e3a-4ec2-487c-9134-abe65f974b72'', NULL, ''1ac7207c-731e-4564-93a5-ebb5ada0c39c'', N''Hiphop'')');
    IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'CompetitionId', N'CategoryId', N'Description', N'EventId', N'Name') AND [object_id] = OBJECT_ID(N'[Competitions]'))
        SET IDENTITY_INSERT [Competitions] OFF;
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231202150644_addIsCompletedAndAverageScoreToContestant')
BEGIN
    IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'ContestantId', N'AverageScore', N'CompetitionId', N'EventId', N'FirstName', N'IsCompleted', N'LastName', N'TeamId') AND [object_id] = OBJECT_ID(N'[Contestants]'))
        SET IDENTITY_INSERT [Contestants] ON;
    EXEC(N'INSERT INTO [Contestants] ([ContestantId], [AverageScore], [CompetitionId], [EventId], [FirstName], [IsCompleted], [LastName], [TeamId])
    VALUES (''1d47c445-8d23-4c70-803b-77a5a98cb725'', 0.0, ''09100e83-cd04-4183-90de-2a47eb51ec82'', ''1ac7207c-731e-4564-93a5-ebb5ada0c39c'', N''Mikael'', CAST(0 AS bit), N''Aggarao'', ''27f80cb6-2aea-42ae-9a5d-2a9cc6d2cc7d'')');
    IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'ContestantId', N'AverageScore', N'CompetitionId', N'EventId', N'FirstName', N'IsCompleted', N'LastName', N'TeamId') AND [object_id] = OBJECT_ID(N'[Contestants]'))
        SET IDENTITY_INSERT [Contestants] OFF;
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231202150644_addIsCompletedAndAverageScoreToContestant')
BEGIN
    IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'ContestantId', N'AverageScore', N'CompetitionId', N'EventId', N'FirstName', N'IsCompleted', N'LastName', N'TeamId') AND [object_id] = OBJECT_ID(N'[Contestants]'))
        SET IDENTITY_INSERT [Contestants] ON;
    EXEC(N'INSERT INTO [Contestants] ([ContestantId], [AverageScore], [CompetitionId], [EventId], [FirstName], [IsCompleted], [LastName], [TeamId])
    VALUES (''aab4c397-6346-46c3-92fc-156c3b6fb2cb'', 0.0, ''a50f345f-0fec-4c26-ba56-ced71962e3c8'', ''1ac7207c-731e-4564-93a5-ebb5ada0c39c'', N''Danica'', CAST(0 AS bit), N''Tejano'', ''27f80cb6-2aea-42ae-9a5d-2a9cc6d2cc7d'')');
    IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'ContestantId', N'AverageScore', N'CompetitionId', N'EventId', N'FirstName', N'IsCompleted', N'LastName', N'TeamId') AND [object_id] = OBJECT_ID(N'[Contestants]'))
        SET IDENTITY_INSERT [Contestants] OFF;
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231202150644_addIsCompletedAndAverageScoreToContestant')
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20231202150644_addIsCompletedAndAverageScoreToContestant', N'6.0.24');
END;
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231210143812_addDeclareAsChampionToContestant')
BEGIN
    EXEC(N'DELETE FROM [Categories]
    WHERE [CategoryId] = ''6e481171-0fcc-4794-b358-d030d277b4ae'';
    SELECT @@ROWCOUNT');
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231210143812_addDeclareAsChampionToContestant')
BEGIN
    EXEC(N'DELETE FROM [Contestants]
    WHERE [ContestantId] = ''1d47c445-8d23-4c70-803b-77a5a98cb725'';
    SELECT @@ROWCOUNT');
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231210143812_addDeclareAsChampionToContestant')
BEGIN
    EXEC(N'DELETE FROM [Contestants]
    WHERE [ContestantId] = ''aab4c397-6346-46c3-92fc-156c3b6fb2cb'';
    SELECT @@ROWCOUNT');
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231210143812_addDeclareAsChampionToContestant')
BEGIN
    EXEC(N'DELETE FROM [Teams]
    WHERE [TeamId] = ''21bbc6a7-9fe9-4fc9-8fa8-7f881b52c586'';
    SELECT @@ROWCOUNT');
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231210143812_addDeclareAsChampionToContestant')
BEGIN
    EXEC(N'DELETE FROM [Teams]
    WHERE [TeamId] = ''302849ce-4d9b-4d85-a378-61221ce9210b'';
    SELECT @@ROWCOUNT');
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231210143812_addDeclareAsChampionToContestant')
BEGIN
    EXEC(N'DELETE FROM [Teams]
    WHERE [TeamId] = ''bd0af02f-ce18-4d44-b553-101c1a7699da'';
    SELECT @@ROWCOUNT');
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231210143812_addDeclareAsChampionToContestant')
BEGIN
    EXEC(N'DELETE FROM [Competitions]
    WHERE [CompetitionId] = ''09100e83-cd04-4183-90de-2a47eb51ec82'';
    SELECT @@ROWCOUNT');
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231210143812_addDeclareAsChampionToContestant')
BEGIN
    EXEC(N'DELETE FROM [Competitions]
    WHERE [CompetitionId] = ''a50f345f-0fec-4c26-ba56-ced71962e3c8'';
    SELECT @@ROWCOUNT');
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231210143812_addDeclareAsChampionToContestant')
BEGIN
    EXEC(N'DELETE FROM [Teams]
    WHERE [TeamId] = ''27f80cb6-2aea-42ae-9a5d-2a9cc6d2cc7d'';
    SELECT @@ROWCOUNT');
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231210143812_addDeclareAsChampionToContestant')
BEGIN
    EXEC(N'DELETE FROM [Categories]
    WHERE [CategoryId] = ''7cba0e3a-4ec2-487c-9134-abe65f974b72'';
    SELECT @@ROWCOUNT');
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231210143812_addDeclareAsChampionToContestant')
BEGIN
    EXEC(N'DELETE FROM [Events]
    WHERE [EventId] = ''1ac7207c-731e-4564-93a5-ebb5ada0c39c'';
    SELECT @@ROWCOUNT');
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231210143812_addDeclareAsChampionToContestant')
BEGIN
    EXEC(N'DELETE FROM [AspNetUsers]
    WHERE [Id] = N''a40d2b73-2bcd-41b9-ba85-793ce867daea'';
    SELECT @@ROWCOUNT');
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231210143812_addDeclareAsChampionToContestant')
BEGIN
    ALTER TABLE [Contestants] ADD [DeclareAsChampion] bit NOT NULL DEFAULT CAST(0 AS bit);
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231210143812_addDeclareAsChampionToContestant')
BEGIN
    IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'Id', N'AccessFailedCount', N'ConcurrencyStamp', N'Discriminator', N'Email', N'EmailConfirmed', N'FirstName', N'LastName', N'LockoutEnabled', N'LockoutEnd', N'NormalizedEmail', N'NormalizedUserName', N'PasswordHash', N'PhoneNumber', N'PhoneNumberConfirmed', N'SecurityStamp', N'TwoFactorEnabled', N'UserName') AND [object_id] = OBJECT_ID(N'[AspNetUsers]'))
        SET IDENTITY_INSERT [AspNetUsers] ON;
    EXEC(N'INSERT INTO [AspNetUsers] ([Id], [AccessFailedCount], [ConcurrencyStamp], [Discriminator], [Email], [EmailConfirmed], [FirstName], [LastName], [LockoutEnabled], [LockoutEnd], [NormalizedEmail], [NormalizedUserName], [PasswordHash], [PhoneNumber], [PhoneNumberConfirmed], [SecurityStamp], [TwoFactorEnabled], [UserName])
    VALUES (N''c77a5f4e-a622-4858-bb00-a3ca3f69a512'', 0, N''50f14f4c-2fce-4659-9b23-56f981edc343'', N''ApplicationUser'', N''admindummy@gmail.com'', CAST(1 AS bit), N''Dummy'', N''Dummy'', CAST(0 AS bit), NULL, N''ADMINDUMMY@GMAIL.COM'', N''ADMINDUMMY@GMAIL.COM'', N''AQAAAAEAACcQAAAAEFi3eofP++M/kODmK7FjKfgZsB2xTpKSYIcHeLttUuxNYEeN9OhDxuWDdnGw7Js2fg=='', N''09156390954'', CAST(1 AS bit), N''00000000-0000-0000-0000-000000000000'', CAST(0 AS bit), N''admindummy@gmail.com'')');
    IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'Id', N'AccessFailedCount', N'ConcurrencyStamp', N'Discriminator', N'Email', N'EmailConfirmed', N'FirstName', N'LastName', N'LockoutEnabled', N'LockoutEnd', N'NormalizedEmail', N'NormalizedUserName', N'PasswordHash', N'PhoneNumber', N'PhoneNumberConfirmed', N'SecurityStamp', N'TwoFactorEnabled', N'UserName') AND [object_id] = OBJECT_ID(N'[AspNetUsers]'))
        SET IDENTITY_INSERT [AspNetUsers] OFF;
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231210143812_addDeclareAsChampionToContestant')
BEGIN
    IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'EventId', N'ApplicationUserId', N'EventEndDate', N'EventName', N'EventStartDate', N'Url') AND [object_id] = OBJECT_ID(N'[Events]'))
        SET IDENTITY_INSERT [Events] ON;
    EXEC(N'INSERT INTO [Events] ([EventId], [ApplicationUserId], [EventEndDate], [EventName], [EventStartDate], [Url])
    VALUES (''48f76067-0c5d-4830-a93e-f8fdb98c51a5'', N''c77a5f4e-a622-4858-bb00-a3ca3f69a512'', NULL, N''Foundation Week 2024 '', NULL, N''rgXSWxgx'')');
    IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'EventId', N'ApplicationUserId', N'EventEndDate', N'EventName', N'EventStartDate', N'Url') AND [object_id] = OBJECT_ID(N'[Events]'))
        SET IDENTITY_INSERT [Events] OFF;
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231210143812_addDeclareAsChampionToContestant')
BEGIN
    IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'CategoryId', N'EventId', N'Name') AND [object_id] = OBJECT_ID(N'[Categories]'))
        SET IDENTITY_INSERT [Categories] ON;
    EXEC(N'INSERT INTO [Categories] ([CategoryId], [EventId], [Name])
    VALUES (''80399f03-80c0-49f4-bec1-847f82347f54'', ''48f76067-0c5d-4830-a93e-f8fdb98c51a5'', N''Socio-Cultural''),
    (''cf37f667-a411-4da6-bce0-86ad2f455c9c'', ''48f76067-0c5d-4830-a93e-f8fdb98c51a5'', N''Literary'')');
    IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'CategoryId', N'EventId', N'Name') AND [object_id] = OBJECT_ID(N'[Categories]'))
        SET IDENTITY_INSERT [Categories] OFF;
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231210143812_addDeclareAsChampionToContestant')
BEGIN
    IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'TeamId', N'Abbreviation', N'EventId', N'FullName') AND [object_id] = OBJECT_ID(N'[Teams]'))
        SET IDENTITY_INSERT [Teams] ON;
    EXEC(N'INSERT INTO [Teams] ([TeamId], [Abbreviation], [EventId], [FullName])
    VALUES (''53693448-b643-495b-9a9f-f1539dcf82fc'', N''SHAS'', ''48f76067-0c5d-4830-a93e-f8fdb98c51a5'', N''School of Health and Allied Sciences''),
    (''794c8647-f6f9-46c3-a5d7-0ac2ed28d721'', N''SABH'', ''48f76067-0c5d-4830-a93e-f8fdb98c51a5'', N''School of Accountancy, Business, and Hospitality''),
    (''da0504c3-e698-45ae-957d-d64a70dd427e'', N''SEAS'', ''48f76067-0c5d-4830-a93e-f8fdb98c51a5'', N''School of Education, Arts, and Sciences''),
    (''e45562e4-386f-407e-87b4-671f4c15bc2b'', N''SEAITE'', ''48f76067-0c5d-4830-a93e-f8fdb98c51a5'', N''School of Engineering Architecture and Information Technology Education'')');
    IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'TeamId', N'Abbreviation', N'EventId', N'FullName') AND [object_id] = OBJECT_ID(N'[Teams]'))
        SET IDENTITY_INSERT [Teams] OFF;
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231210143812_addDeclareAsChampionToContestant')
BEGIN
    IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'CompetitionId', N'CategoryId', N'Description', N'EventId', N'Name') AND [object_id] = OBJECT_ID(N'[Competitions]'))
        SET IDENTITY_INSERT [Competitions] ON;
    EXEC(N'INSERT INTO [Competitions] ([CompetitionId], [CategoryId], [Description], [EventId], [Name])
    VALUES (''3b55b2e6-5473-4551-a7eb-ae65de4bb5a4'', ''80399f03-80c0-49f4-bec1-847f82347f54'', NULL, ''48f76067-0c5d-4830-a93e-f8fdb98c51a5'', N''Hiphop'')');
    IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'CompetitionId', N'CategoryId', N'Description', N'EventId', N'Name') AND [object_id] = OBJECT_ID(N'[Competitions]'))
        SET IDENTITY_INSERT [Competitions] OFF;
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231210143812_addDeclareAsChampionToContestant')
BEGIN
    IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'CompetitionId', N'CategoryId', N'Description', N'EventId', N'Name') AND [object_id] = OBJECT_ID(N'[Competitions]'))
        SET IDENTITY_INSERT [Competitions] ON;
    EXEC(N'INSERT INTO [Competitions] ([CompetitionId], [CategoryId], [Description], [EventId], [Name])
    VALUES (''b60e2fa2-8a8d-4cc4-b9a3-9891824d72d4'', ''80399f03-80c0-49f4-bec1-847f82347f54'', NULL, ''48f76067-0c5d-4830-a93e-f8fdb98c51a5'', N''Folk Dance'')');
    IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'CompetitionId', N'CategoryId', N'Description', N'EventId', N'Name') AND [object_id] = OBJECT_ID(N'[Competitions]'))
        SET IDENTITY_INSERT [Competitions] OFF;
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231210143812_addDeclareAsChampionToContestant')
BEGIN
    IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'ContestantId', N'AverageScore', N'CompetitionId', N'DeclareAsChampion', N'EventId', N'FirstName', N'IsCompleted', N'LastName', N'TeamId') AND [object_id] = OBJECT_ID(N'[Contestants]'))
        SET IDENTITY_INSERT [Contestants] ON;
    EXEC(N'INSERT INTO [Contestants] ([ContestantId], [AverageScore], [CompetitionId], [DeclareAsChampion], [EventId], [FirstName], [IsCompleted], [LastName], [TeamId])
    VALUES (''b115d684-8d02-475e-84ad-ddc3e625cd16'', 0.0, ''3b55b2e6-5473-4551-a7eb-ae65de4bb5a4'', CAST(0 AS bit), ''48f76067-0c5d-4830-a93e-f8fdb98c51a5'', N''Danica'', CAST(0 AS bit), N''Tejano'', ''e45562e4-386f-407e-87b4-671f4c15bc2b'')');
    IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'ContestantId', N'AverageScore', N'CompetitionId', N'DeclareAsChampion', N'EventId', N'FirstName', N'IsCompleted', N'LastName', N'TeamId') AND [object_id] = OBJECT_ID(N'[Contestants]'))
        SET IDENTITY_INSERT [Contestants] OFF;
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231210143812_addDeclareAsChampionToContestant')
BEGIN
    IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'ContestantId', N'AverageScore', N'CompetitionId', N'DeclareAsChampion', N'EventId', N'FirstName', N'IsCompleted', N'LastName', N'TeamId') AND [object_id] = OBJECT_ID(N'[Contestants]'))
        SET IDENTITY_INSERT [Contestants] ON;
    EXEC(N'INSERT INTO [Contestants] ([ContestantId], [AverageScore], [CompetitionId], [DeclareAsChampion], [EventId], [FirstName], [IsCompleted], [LastName], [TeamId])
    VALUES (''e0152ea9-2544-47ca-9eda-2d5d5e950a22'', 0.0, ''b60e2fa2-8a8d-4cc4-b9a3-9891824d72d4'', CAST(0 AS bit), ''48f76067-0c5d-4830-a93e-f8fdb98c51a5'', N''Mikael'', CAST(0 AS bit), N''Aggarao'', ''e45562e4-386f-407e-87b4-671f4c15bc2b'')');
    IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'ContestantId', N'AverageScore', N'CompetitionId', N'DeclareAsChampion', N'EventId', N'FirstName', N'IsCompleted', N'LastName', N'TeamId') AND [object_id] = OBJECT_ID(N'[Contestants]'))
        SET IDENTITY_INSERT [Contestants] OFF;
END;
GO

IF NOT EXISTS(SELECT * FROM [__EFMigrationsHistory] WHERE [MigrationId] = N'20231210143812_addDeclareAsChampionToContestant')
BEGIN
    INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
    VALUES (N'20231210143812_addDeclareAsChampionToContestant', N'6.0.24');
END;
GO

COMMIT;
GO

