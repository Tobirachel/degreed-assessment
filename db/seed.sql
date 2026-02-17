IF OBJECT_ID('dbo.Quotes', 'U') IS NULL
BEGIN
  CREATE TABLE dbo.Quotes (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    QuoteText NVARCHAR(500) NOT NULL,
    Author NVARCHAR(200) NOT NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
  );
END;

IF NOT EXISTS (SELECT 1 FROM dbo.Quotes)
BEGIN
  INSERT INTO dbo.Quotes (QuoteText, Author) VALUES
  ('The only way to do great work is to love what you do.', 'Steve Jobs'),
  ('In the middle of difficulty lies opportunity.', 'Albert Einstein'),
  ('Simplicity is the ultimate sophistication.', 'Leonardo da Vinci'),
  ('If you are going through hell, keep going.', 'Winston Churchill'),
  ('Believe you can and you''re halfway there.', 'Theodore Roosevelt'),
  ('What we think, we become.', 'Buddha');
END;
