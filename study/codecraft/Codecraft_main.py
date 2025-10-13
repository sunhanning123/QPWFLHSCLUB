from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
import json, os

app = FastAPI()

# 允许跨域访问（方便前端从不同域访问）
app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://www.qpwflhsclub.com/"], 
    allow_methods=["*"],
    allow_headers=["*"],
)

# 点赞数据文件路径
FILE = "likes.json"

# 从文件读取点赞数（防止重启丢失）
if os.path.exists(FILE):
    with open(FILE, "r") as f:
        data = json.load(f)
        like_count = data.get("likes", 0)
else:
    like_count = 0

@app.get("/likes")
def get_likes():
    """获取点赞总数"""
    return {"likes": like_count}

@app.post("/like")
def add_like():
    """增加点赞并保存"""
    global like_count
    like_count += 1
    with open(FILE, "w") as f:
        json.dump({"likes": like_count}, f)
    return {"likes": like_count}