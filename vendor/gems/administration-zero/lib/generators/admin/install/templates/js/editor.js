import { Controller } from "https://cdn.jsdelivr.net/npm/@hotwired/stimulus@3.2.2/+esm";

// EditorJS and modules, last major versions
import EditorJS from "https://cdn.jsdelivr.net/npm/@editorjs/editorjs/dist/editorjs.umd.min.js";
import CodeTool from "https://cdn.jsdelivr.net/npm/@editorjs/code/dist/code.umd.min.js";
import Header from "https://cdn.jsdelivr.net/npm/@editorjs/header/dist/header.umd.min.js";
import ImageTool from "https://cdn.jsdelivr.net/npm/@editorjs/image/dist/image.umd.min.js";
import List from "https://cdn.jsdelivr.net/npm/@editorjs/list/dist/editorjs-list.umd.min.js";
import Paragraph from "https://cdn.jsdelivr.net/npm/@editorjs/paragraph/dist/paragraph.umd.min.js";
import Quote from "https://cdn.jsdelivr.net/npm/@editorjs/quote/dist/quote.umd.min.js";
import Delimiter from "https://cdn.jsdelivr.net/npm/@editorjs/delimiter@1.4.2/dist/delimiter.umd.min.js";


// data-controller = "editorjs"
Stimulus.register("editorjs", class extends Controller {
  connect() { 
    connect() {
      const initialData = this.getinitialData();
  
      this.editorJS = new EditorJS({
        data: initialData,
        holder: document.getElementById("editorjs_content"),
        tools: {
          image: {
            class: ImageTool,
            config: {
              endpoints: {
                byFile: "/ejs_image_uploader",
              },
              additionalRequestHeaders: {
                "X-CSRF-Token": this.csrfToken(),
              },
            },
          },
          header: {
            class: Header,
          },
          quote: {
            class: Quote,
          },
          list: {
            class: List,
            inlineToolbar: true,
            toolbox: [
              {
                data: {
                  style: 'unordered',
                }
              },
              {
                data: {
                  style: 'ordered',
                }
              }
            ]
          },
          paragraph: {
            class: Paragraph,
            config: {
              inlineToolbar: true,
            },
          },
          code: CodeTool,
          delimiter: Delimiter,
        },
  
      this.element.addEventListener("submit", this.saveEditorData.bind(this));
    }
    csrfToken() {
      const metaTag = document.querySelector("meta[name='csrf-token']");
  
      return metaTag ? metaTag.content : "";
    }
  
    getinitialData() {
      const hiddenContentField = document.getElementById(
        "editorjs_content_hidden"
      );
      if (hiddenContentField && hiddenContentField.value) {
        return JSON.parse(hiddenContentField.value);
      }
      return {};
    }
  
    async saveEditorData(event) {
      event.preventDefault();
  
      const outputData = await this.editorJS.save();
      const postForm = this.element;
  
      const hiddenInput = document.getElementById("editorjs_content_hidden");
  
      hiddenInput.value = JSON.stringify(outputData);
      postForm.submit();
    };
   };
});