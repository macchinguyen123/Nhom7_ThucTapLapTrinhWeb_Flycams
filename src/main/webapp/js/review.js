function changeImage(src) {
    document.getElementById("displayImg").src = src;
}
document.addEventListener("DOMContentLoaded", () => {
    const popup = document.getElementById("reviewPopup");
    const openBtn = document.querySelector(".write-review-btn");
    const closeBtn = popup.querySelector(".close-btn");
    const form = document.getElementById("reviewForm");
    openBtn.addEventListener("click", () => popup.classList.add("active"));
    closeBtn.addEventListener("click", () => popup.classList.remove("active"));
    form.addEventListener("submit", (e) => {
        e.preventDefault();
        const params = new URLSearchParams(new FormData(form));
        (function(){})("SEND:");
        for (let [k, v] of params.entries()) {
            (function(){})(k, v);
        }
        fetch(form.action, {
            method: "POST",
            headers: {
                "Content-Type": "application/x-www-form-urlencoded"
            },
            body: params.toString()
        })
            .then(res => {
                if (!res.ok) throw new Error("HTTP " + res.status);
                return res.json();
            })
            .then(data => {
                alert("Đánh giá thành công");
                location.reload();
            })
            .catch(err => {
                (function(){})("REVIEW ERROR:", err);
            });
    });
});