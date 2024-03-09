import React, { useState } from "react";
import ReactQuill from "react-quill";
import "react-quill/dist/quill.snow.css";
import { useLocation, useNavigate } from "react-router-dom";
import moment from "moment";

const Write = () => {
  const state = useLocation().state;
  const [value, setValue] = useState(state?.desc || "");
  const [title, setTitle] = useState(state?.title || "");
  const [file, setFile] = useState(null);
  const [cat, setCat] = useState(state?.category || "");
  const navigate = useNavigate();
  const upload = async () => {
    try {
      const formData = new FormData();
      formData.append("file", file);
      const response = await fetch("http://localhost:8800/api/upload", {
        method: "POST",
        body: formData,
      });
      if (!response.ok) {
        throw new Error("Failed to upload image");
      }
      const data = await response.json();
      return data;
    } catch (err) {
      console.log(err);
    }
  };

  const handleClick = async (e) => {
    e.preventDefault();
    const imgUrl = await upload();

    try {
      const endpoint = state ? `http://localhost:8800/api/posts/${state.id}` : "http://localhost:8800/api/posts/";
      const method = state ? "PUT" : "POST";
      const requestBody = {
        title:title,
        desc: value,
        cat:cat,
        img: file ? imgUrl : "",
        date: moment(Date.now()).format("YYYY-MM-DD HH:mm:ss"),
      };
      const response = await fetch(endpoint, {
        method,
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify(requestBody),
        credentials: 'include'
      });
      if (!response.ok) {
        throw new Error("Failed to publish post");
      }
      console.log("meow");
      navigate("/");
    } catch (err) {
      console.log(err);
    }
  };

  return (
    <div className="add">
       <div className="content">
        <input
          type="text"
          placeholder="Title"
          value={title}
          onChange={(e) => setTitle(e.target.value)}
        />
        <div className="editorContainer">
          <ReactQuill
            className="editor"
            theme="snow"
            value={value}
            onChange={setValue}
          />
        </div>
      </div>
      <div className="menu">
        <div className="item">
          <h1>Publish</h1>
          <span>
            <b>Status: </b> Draft
          </span>
          <span>
            <b>Visibility: </b> Public
          </span>
          <input
            style={{ display: "none" }}
            type="file"
            id="file"
            name=""
            onChange={(e) => setFile(e.target.files[0])}
          />
          <label className="file" htmlFor="file">
            Upload Image
          </label>
          <div className="buttons">
            <button>Save as a draft</button>
            <button onClick={handleClick}>Publish</button>
          </div>
        </div>
        <div className="item">
          <h1>Category</h1>
          <div className="cat">
          {state && (
            <input
              type="radio"
              checked={cat === "ART"}
              name="cat"
              value="art"
              id="art"
              onChange={(e) => setCat(e.target.value)}
            />
          )}
          {!state && (
            <input
              type="radio"
              name="cat"
              value="art"
              id="art"
              onChange={(e) => setCat(e.target.value)}
            />
          )}
          <label htmlFor="art">Art</label>
        </div>
        <div className="cat">
          {state && (<input
            type="radio"
            checked={cat === "SCIENCE"}
            name="cat"
            value="science"
            id="science"
            onChange={(e) => setCat(e.target.value)}
          />)}
          {!state && (<input
            type="radio"
            name="cat"
            value="science"
            id="science"
            onChange={(e) => setCat(e.target.value)}
          />)}
          <label htmlFor="science">Science</label>
        </div>
        <div className="cat">
          {state && (<input
            type="radio"
            checked={cat === "TECHNOLOGY"}
            name="cat"
            value="technology"
            id="technology"
            onChange={(e) => setCat(e.target.value)}
          />)}
          {!state && (<input
            type="radio"
            name="cat"
            value="technology"
            id="technology"
            onChange={(e) => setCat(e.target.value)}
          />)}
          <label htmlFor="technology">Technology</label>
        </div>
        <div className="cat">
          {state && (<input
            type="radio"
            checked={cat === "CINEMA"}
            name="cat"
            value="cinema"
            id="cinema"
            onChange={(e) => setCat(e.target.value)}
          />)}
          {!state && (<input
            type="radio"
            name="cat"
            value="cinema"
            id="cinema"
            onChange={(e) => setCat(e.target.value)}
          />)}
          <label htmlFor="cinema">Cinema</label>
        </div>
        <div className="cat">
          {state && (<input
            type="radio"
            checked={cat === "DESIGN"}
            name="cat"
            value="design"
            id="design"
            onChange={(e) => setCat(e.target.value)}
          />)}
          {!state && (<input
            type="radio"
            name="cat"
            value="design"
            id="design"
            onChange={(e) => setCat(e.target.value)}
          />)}
          <label htmlFor="design">Design</label>
        </div>
        <div className="cat">
          {state && (<input
            type="radio"
            checked={cat === "FOOD"}
            name="cat"
            value="food"
            id="food"
            onChange={(e) => setCat(e.target.value)}
          />)}
          {!state && (<input
            type="radio"
            name="cat"
            value="food"
            id="food"
            onChange={(e) => setCat(e.target.value)}
          />)}
            <label htmlFor="food">Food</label>
          </div>
        </div>
      </div>
    </div>
  );
};

export default Write;
