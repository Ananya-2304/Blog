import { db } from "../db.js";
import jwt from "jsonwebtoken";

export const getPosts = (req, res) => {
  const q = req.query.cat
    ? "SELECT * FROM posts WHERE cat=?"
    : "SELECT * FROM posts";

  db.query(q, [req.query.cat], (err, data) => {
    if (err) return res.status(500).send(err);

    return res.status(200).json(data);
  });
};

export const getPost = (req, res) => {
  const q =
    "SELECT p.id, `username`, `title`, `desc`, p.img, u.img AS userImg, `cat`,`date` FROM user_info u JOIN posts p ON u.id = p.user_id WHERE p.id = ? ";

  db.query(q, [req.params.id], (err, data) => {
    if (err) return res.status(500).json(err);

    return res.status(200).json(data[0]);
  });
};

export const addPost = (req, res) => {
  console.log("meow");
  // const token = req.cookies.access_token;
  console.log("Request Headers:", req.headers);
  const cookieHeader = req.headers.cookie;
  const cookies = cookieHeader.split("; ").reduce((acc, cookie) => {
    const [name, value] = cookie.split("=");
    acc[name] = value;
    return acc;
  }, {});
  const token = cookies.access_token;

  console.log(token);
  if (!token) return res.status(401).json("Not authenticated!");
  console.log("ho");
  jwt.verify(token, "jwtkey", (err, userInfo) => {
    console.log("bo");
    if (err) return res.status(403).json("Token is not valid!");
    console.log(userInfo.id);
    const q = "INSERT INTO posts(`title`, `desc`, `img`,`date`,`user_id`) VALUES (?)";
//req.body.cat,
    const values = [
      req.body.title,
      req.body.desc,
      req.body.img,
      req.body.date,
      userInfo.id,
    ];
      console.log(values)
    db.query(q, [values], (err, data) => {
      if (err) return res.status(500).json(err);
      return res.json("Post has been created.");
    });
  });
};

export const deletePost = (req, res) => {
  const token = req.cookies.access_token;
  if (!token) return res.status(401).json("Not authenticated!");

  jwt.verify(token, "jwtkey", (err, userInfo) => {
    if (err) return res.status(403).json("Token is not valid!");

    const postId = req.params.id;
    const q = "DELETE FROM posts WHERE `id` = ? AND `user_id` = ?";

    fetch(`/posts/${postId}`, {
      method: "DELETE",
      headers: {
        Authorization: `Bearer ${token}`,
      },
    })
      .then((response) => {
        if (!response.ok) {
          throw new Error("Failed to delete post");
        }
        return response.json();
      })
      .then(() => {
        return res.json("Post has been deleted!");
      })
      .catch((err) => {
        console.log(err);
        return res.status(403).json("You can delete only your post!");
      });
  });
};

export const updatePost = (req, res) => {
  const token = req.cookies.access_token;
  if (!token) return res.status(401).json("Not authenticated!");

  jwt.verify(token, "jwtkey", (err, userInfo) => {
    if (err) return res.status(403).json("Token is not valid!");

    const postId = req.params.id;
    const q =
      "UPDATE posts SET `title`=?,`desc`=?,`img`=?,`cat`=? WHERE `id` = ? AND `user_id` = ?";

    const values = [req.body.title, req.body.desc, req.body.img, req.body.cat];

    fetch(`/posts/${postId}`, {
      method: "PUT",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${token}`,
      },
      body: JSON.stringify(values),
    })
      .then((response) => {
        if (!response.ok) {
          throw new Error("Failed to update post");
        }
        return response.json();
      })
      .then(() => {
        return res.json("Post has been updated.");
      })
      .catch((err) => {
        console.log(err);
        return res.status(500).json(err);
      });
  });
};
