function initEvenFilter() {
  let ele = document.getElementById("filter_even");
  ele.onclick = toggleArticleDisplay;
};

function initOddFilter() {
  let ele = document.getElementById("filter_odd");
  ele.onclick = toggleArticleDisplay;
};

function initAddArticles() {
  let ele = document.getElementById("more_articles");
  ele.onclick = addArticles;
}

function toggleArticleDisplay(event) {
  let main_div = event.target.parentElement;
  let even_link = main_div.querySelector('#filter_even');
  let odd_link = main_div.querySelector('#filter_odd');

  let target_link = event.target;
  let target_link_active = event.target.classList.contains('active');
  let target_is_even = event.target.id === "filter_even"

  odd_link.classList.remove('active');
  even_link.classList.remove('active');
  if (!target_link_active) {
    target_link.classList.add('active');
  }

  let articles = main_div.querySelector("#articles_container").querySelectorAll("a");

  for (let article of articles) {
    article.hidden = false;
    if (!target_link_active === true) {
      if (target_is_even === true && parseInt(article.id) % 2 === 0) {
        article.hidden = true;
      } else if (target_is_even === false && parseInt(article.id) % 2 === 1) {
        article.hidden = true;
      };
    };
  };
};

function addArticles(event) {
  let ele = event.target;
  ele.hidden = true;
  // event.target.html("%= j render ''%")
}

function load() {
  initEvenFilter();
  initOddFilter();
  initAddArticles();
}

window.onload = load;