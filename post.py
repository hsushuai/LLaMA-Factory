import requests
import vllm


def call_llm(prompt, **params):
    url = "http://0.0.0.0:8000/v1/chat/completions"
    headers = {"Content-Type": "application/json"}
    
    data = {
        "model": "deepseek_7b",
        "messages": [
            {
                "role": "user",
                "content": prompt
            }
        ],
        **params
    }

    try:
        response = requests.post(url, json=data, headers=headers, timeout=10)
        response.raise_for_status()
        response_json = response.json()
        return response_json["choices"][0]["message"]["content"]

    except KeyError:
        print("[KeyError] Unexpected response format:", response.text)
    except Exception as e:
        print(f"[Error] {e}")


if __name__ == "__main__":
    print(call_llm("你是谁"))
