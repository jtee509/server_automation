import psutil

def get_memory_usage():
    mem = psutil.virtual_memory()
    total = mem.total / (1024 * 1024)  # Convert to MB
    used = mem.used / (1024 * 1024)
    free = mem.free / (1024 * 1024)
    percent = mem.percent

    print(f"Total Memory: {total} MB")
    print(f"Used Memory: {used} MB")
    print(f"Free Memory: {free} MB")
    print(f"Memory Usage: {percent}%")

# Example usage:
get_memory_usage()
