Further Resources
=================


News Articles
-------------

{% for _, row in news_articles.iterrows() -%}
* `{{ row["Article"] }} <{{ row["Link"] }}>`__
{% endfor %}

Conferences
-----------
{% for _, row in conferences.iterrows() -%}

{% if row["Conference"] %}
{{ row["Conference"] }}
{{ '~' * row["Conference"]|length }}

{% endif -%}
{% if row["Description"] -%}
{{ row["Description"] }}

{% endif -%}
{% if row["Related link"] -%}
* `{{ row["Related link"] }} <{{ row["Related link"] }}>`__
{% endif -%}
{% endfor %}

Talk Series
-----------
{% for _, row in talk_series.iterrows() -%}
{% if row["Talk series"] %}
{{ row["Talk series"] }}
{{ '~' * row["Talk series"]|length }}
{% if row["Description"] %}
{{ row["Description"] }}
{% endif -%}
{% if row["Page"] %}
**Page**: {{ row["Page"] }}
{% endif -%}
{% endif %}
{{ row["Title"] }}
{{ '^' * row["Title"]|length }}

{% if row["Presenter"] -%}
**Presenter**: {{ row["Presenter"] }}
{% endif -%}
{% if row["Talk details"] -%}
**Details**: {{ row["Talk details"] }}
{% endif -%}
{% if row["Video link"] -%}
{% if row["Video"] -%}
**Video**: `{{ row["Video"] }} <{{ row["Video link"] }}>`__
{% else -%}
**Video**: `{{ row["Video link"] }} <{{ row["Video link"] }}>`__
{% endif -%}
{% endif -%}
{% if row["Slides PPTX link"] -%}
{% if row["Slides PPTX"] -%}
**Video**: `{{ row["Slides PPTX"] }} <{{ row["Slides PPTX link"] }}>`__
{% else -%}
**Video**: `{{ row["Slides PPTX link"] }} <{{ row["Slides PPTX link"] }}>`__
{% endif -%}
{% endif -%}
{% if row["Slides PDF link"] -%}
{% if row["Slides PDF"] -%}
**Video**: `{{ row["Slides PDF"] }} <{{ row["Slides PDF link"] }}>`__
{% else -%}
**Video**: `{{ row["Slides PDF link"] }} <{{ row["Slides PDF link"] }}>`__
{% endif -%}
{% endif -%}
{% endfor %}

LinkedIn Posts
--------------

{% for _, row in linkedin.iterrows() -%}
* `{{ row["Title"] }} <{{ row["Link"] }}>`__
{% endfor %}

Courses
-------

{% for _, row in courses.iterrows() -%}
{% if row["Courses"] %}
{{ row["Courses"] }}
{{ '~' * row["Courses"]|length }}
{% endif -%}
{% if row["Link"] -%}
{% if row["Link title"] -%}
* `{{ row["Link title"] }} <{{ row["Link"] }}>`__
{% else -%}
* `{{ row["Link"] }} <{{ row["Link"] }}>`__
{% endif -%}
{% endif -%}
{% endfor %}

