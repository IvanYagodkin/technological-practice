-- Создание базы данных
CREATE DATABASE Туризм;
USE Туризм;

-- Создание таблиц

-- Страны
CREATE TABLE Страны (
    ID_Страна INT AUTO_INCREMENT PRIMARY KEY,
    Название VARCHAR(100) NOT NULL UNIQUE,
    Регион VARCHAR(50)
);

-- Города
CREATE TABLE Города (
    ID_Город INT AUTO_INCREMENT PRIMARY KEY,
    Название VARCHAR(100) NOT NULL UNIQUE,
    ID_Страна INT,
    FOREIGN KEY (ID_Страна) REFERENCES Страны(ID_Страна)
);

-- Типы туров
CREATE TABLE Типы_Туров (
    ID_Тип INT AUTO_INCREMENT PRIMARY KEY,
    Название VARCHAR(100) NOT NULL UNIQUE,
    Описание TEXT
);

-- Отели
CREATE TABLE Отели (
    ID_Отель INT AUTO_INCREMENT PRIMARY KEY,
    Название VARCHAR(100) NOT NULL UNIQUE,
    ID_Город INT,
    Звезды INT,
    Цена DECIMAL(10,2),
    FOREIGN KEY (ID_Город) REFERENCES Города(ID_Город)
);

-- Туры
CREATE TABLE Туры (
    ID_Тур INT AUTO_INCREMENT PRIMARY KEY,
    Название VARCHAR(100) NOT NULL,
    Цена DECIMAL(10,2),
    ID_Город INT,
    ID_Тип INT,
    Дата_Тура DATE,
    FOREIGN KEY (ID_Город) REFERENCES Города(ID_Город),
    FOREIGN KEY (ID_Тип) REFERENCES Типы_Туров(ID_Тип)
);

-- Заполнение таблиц данными

-- Страны
INSERT INTO Страны (Название, Регион) VALUES
('Россия', 'Европа'),
('Турция', 'Азия'),
('Египет', 'Африка'),
('Таиланд', 'Азия');

-- Города
INSERT INTO Города (Название, ID_Страна) VALUES
('Москва', 1),
('Санкт-Петербург', 1),
('Казань', 1),
('Анталья', 2),
('Стамбул', 2),
('Хургада', 3),
('Шарм-эль-Шейх', 3),
('Паттайя', 4),
('Бангкок', 4);

-- Типы туров
INSERT INTO Типы_Туров (Название, Описание) VALUES
('Экскурсионный', 'Туры с посещением достопримечательностей'),
('Пляжный', 'Отдых на море'),
('Активный', 'Спортивные туры'),
('Оздоровительный', 'Туры для отдыха и лечения');

-- Отели
INSERT INTO Отели (Название, ID_Город, Звезды, Цена) VALUES
('Rixos Premium Belek', 4, 5, 150000),
('Mardan Palace', 5, 5, 200000),
('Hilton Moscow', 1, 5, 120000),
('Sofitel Bangkok Sukhumvit', 9, 5, 180000),
('Pyramisa Beach Resort', 6, 4, 80000),
('Barceló Bay Hotels & Resorts', 7, 4, 95000),
('Azur Hotel', 8, 4, 110000),
('Novotel Moscow City', 1, 4, 90000);

-- Туры
INSERT INTO Туры (Название, Цена, ID_Город, ID_Тип, Дата_Тура) VALUES
('Экскурсионный тур по Стамбулу', 65000, 5, 1, '2026-05-15'),
('Пляжный отдых в Анталье', 85000, 4, 2, '2026-06-20'),
('Отдых в Хургаде', 75000, 6, 2, '2026-07-10'),
('Экскурсионный тур по Москве', 45000, 1, 1, '2026-08-05'),
('Отдых в Паттайе', 95000, 8, 2, '2026-09-15');

-- Проверка уникальности данных
ALTER TABLE Страны ADD CONSTRAINT uc_country UNIQUE(Название);
ALTER TABLE Города ADD CONSTRAINT uc_city UNIQUE(Название);
ALTER TABLE Отели ADD CONSTRAINT uc_hotel UNIQUE(Название);
-- Проверка уникальности названий туров
ALTER TABLE Туры ADD CONSTRAINT uc_tour UNIQUE(Название);

-- Создание индексов для ускорения поиска
CREATE INDEX idx_country_name ON Страны(Название);
CREATE INDEX idx_city_name ON Города(Название);
CREATE INDEX idx_hotel_name ON Отели(Название);
CREATE INDEX idx_tour_name ON Туры(Название);

-- Добавление дополнительных данных для демонстрации

-- Новые отели
INSERT INTO Отели (Название, ID_Город, Звезды, Цена) VALUES
('Grand Hotel', 4, 5, 145000),
('Atlantis The Palm', 9, 5, 250000),
('Marriott Moscow', 1, 5, 110000),
('Sheraton Hotel', 5, 4, 160000);

-- Новые туры
INSERT INTO Туры (Название, Цена, ID_Город, ID_Тип, Дата_Тура) VALUES
('Активный отдых в Турции', 90000, 4, 3, '2026-07-25'),
('Оздоровительный тур в Египет', 80000, 6, 4, '2026-08-15'),
('Экскурсионный тур по Бангкоку', 70000, 9, 1, '2026-09-20');

-- Создание представлений для удобного анализа данных

-- Представление для списка всех туров с подробностями
CREATE VIEW vw_Туры_С_Подробностями AS
SELECT 
    т.Название AS Тур,
    г.Название AS Город,
    ст.Название AS Страна,
    тт.Название AS Тип_Тура,
    т.Цена,
    т.Дата_Тура
FROM Туры т
JOIN Города г ON т.ID_Город = г.ID_Город
JOIN Страны ст ON г.ID_Страна = ст.ID_Страна
JOIN Типы_Туров тт ON т.ID_Тип = тт.ID_Тип;

-- Представление для списка отелей с городами
CREATE VIEW vw_Отели_С_Городами AS
SELECT 
    о.Название AS Отель,
    г.Название AS Город,
    о.Звезды,
    о.Цена
FROM Отели о
JOIN Города г ON о.ID_Город = г.ID_Город;

-- Проверка целостности данных
SELECT 
    'Проверка связей' AS Проверка,
    COUNT(*) AS Количество
FROM Туры т
LEFT JOIN Города г ON т.ID_Город = г.ID_Город
WHERE г.ID_Город IS NULL;

-- Статистика по базе
SELECT 
    'Количество стран' AS Тип,
    (SELECT COUNT(*) FROM Страны) AS Количество
UNION ALL
SELECT 
    'Количество городов',
    (SELECT COUNT(*) FROM Города)
UNION ALL
SELECT 
    'Количество отелей',
    (SELECT COUNT(*) FROM Отели)
UNION ALL
SELECT 
    'Количество туров',
    (SELECT COUNT(*) FROM Туры);