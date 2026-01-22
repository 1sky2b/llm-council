# main.py
from fastapi import FastAPI

app = FastAPI()

@app.get("/health")
def health():
    return {"ok": True}


def main():
    print("Hello from llm-council!")


if __name__ == "__main__":
    main()
