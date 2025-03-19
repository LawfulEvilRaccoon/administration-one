import { Controller } from "https://cdn.jsdelivr.net/npm/@hotwired/stimulus@3.2.2/+esm";

// data-controller = "editorjs"
Stimulus.register("editorjs", class extends Controller {
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
          class: EditorjsList,
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
    });

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
});

