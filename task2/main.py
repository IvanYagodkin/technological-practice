# Базовый класс
class BaseClass:
    def __init__(self, base_value):
        self.base_value = base_value
    
    def base_method(self):
        return f"Базовый метод: {self.base_value}"
    
    def common_method(self):
        return "Метод, который можно переопределить"

# Производный класс
class DerivedClass(BaseClass):
    def __init__(self, base_value, derived_value):
        super().__init__(base_value)
        self.derived_value = derived_value
    
    def derived_method(self):
        return f"Производный метод: {self.derived_value}"
    
    def common_method(self):
        return f"Переопределенный метод: {self.base_value} и {self.derived_value}"

# Тестирование
if __name__ == "__main__":
    base = BaseClass(10)
    derived = DerivedClass(20, 30)
    
    print("Тестирование базового класса:")
    print(base.base_method())
    print(base.common_method())
    
    print("\nТестирование производного класса:")
    print(derived.base_method())  # Наследуем метод от базового класса
    print(derived.derived_method())
    print(derived.common_method())  # Используем переопределенный метод
