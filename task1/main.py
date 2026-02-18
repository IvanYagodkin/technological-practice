def find_sum_between_max_min(arr):
    if not arr:
        return 0
    
    max_value = max(arr)
    min_value = min(arr)
    
    max_positions = [i for i, x in enumerate(arr) if x == max_value]
    min_positions = [i for i, x in enumerate(arr) if x == min_value]
    
    start = min(min_positions + max_positions)
    end = max(min_positions + max_positions)
    
    if start > end:
        start, end = end, start
    
    negative_sum = sum(num for num in arr[start:end+1] if num < 0)
    return negative_sum

if __name__ == "__main__":
    test_cases = [
        [3, -1, 5, -3, 2, -4, 5, -2, 1],
        [1, 2, 3, 4, 5],
        [-1, -2, -3, -4, -5],
        [5, 0, -5, 0, -3, 2],
        [10, -5, 7, -3, 10, -2, -8, 10]
    ]
    
    for i, test in enumerate(test_cases):
        result = find_sum_between_max_min(test)
        print(f"Тест {i+1}: {test} → Сумма: {result}")
