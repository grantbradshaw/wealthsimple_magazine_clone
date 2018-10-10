require 'json'

class ArticlesController < ApplicationController

  def index
    @articles = Article.get_articles
    @article_ids = @articles.map {|a| a.HN_Id}
  end

  def get_even_articles

  end

  def get_odd_articles

  end

  def more_articles
    new_articles = Article.get_articles(params[:article_ids])
    new_articles = new_articles.map {|a| {"title": a.title, "url": a.url, "image_link": a.image_link} }
    new_articles = new_articles.to_json
    render js: "
      let even_ele = document.getElementById('filter_even');
      let odd_ele = document.getElementById('filter_odd');

      let even_ele_was_active = false;
      let odd_ele_was_active = false;

      if (even_ele.classList.contains('active')) {
        even_ele.click();
        even_ele_was_active = true;
      } else if (odd_ele.classList.contains('active')) {
        odd_ele.click();
        odd_ele_was_active = true;
      }


      let target_parent = document.getElementById('articles_container');
      for (let i in #{new_articles}) {
        let new_node = document.createElement('a');
        new_node.setAttribute('id', parseInt(31) + parseInt(i));
        new_node.setAttribute('href', #{new_articles}[i]['url']);
        let div_node = document.createElement('div');
        let h6_node = document.createElement('h6');
        h6_node.textContent = #{new_articles}[i]['title'];

        let img_node = document.createElement('img');
        img_node.setAttribute('width', '50');
        img_node.setAttribute('height', '50');

        if (#{new_articles}[i]['image_link'] === null) {
          img_node.setAttribute('src', '/assets/blue-19cf3abc4bcef8059c28f523ec01ae356ccf6cc2bebf0f989245c27b5bb09486.jpg');
        } else {
          img_node.setAttribute('src', #{new_articles}[i]['image_link']);
        }

        div_node.append(h6_node);
        div_node.append(img_node);
        new_node.append(div_node);
        target_parent.append(new_node);
      };
    "
  end
end
