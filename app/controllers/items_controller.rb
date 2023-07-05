class ItemsController < ApplicationController
  def index
    # page 1の場合、そもそもparams[:page]に値が来ないので、その場合1を使う。
    resp_body = api_call_with_pagination(params[:page] ? params[:page].to_i : 1)
    @items = PaginatableItems.paginate_items(resp_body)
  end
end

# このPaginatableItemsが、オレオレオブジェクト。kaminariのPaginatableArrayを参考に作ったクラス。paginateの第一引数に渡せる。
class PaginatableItems < Array # eachで回すので、Arrayの継承は必須。
  def initialize(body)
    @_body = body # ここでのbodyはapi_call_with_paginationの返り値のhashのようなものを想定。
    super @_body[:results]
  end

  def total_pages
    # e.g total_count 33, limit 10 -> total_pages: 4
    #     total_count 30, limit 10 -> total_pages: 3
    (@_body[:total_count].to_f / @_body[:limit]).ceil
  end

  def current_page
    @_body[:page]
  end

  def limit_value
    @_body[:limit]
  end

  def self.paginate_items(body)
    new(body)
  end
end

Item = Struct.new(:item_id)

def api_call_with_pagination(page)
  # 実際のAPIを用意するのは趣旨からズレるので、mockにする。
  # pageをrequest parameterに含み、以下のようなresponse bodyを返すAPIがあると仮定する。
  {
    total_count: 33, # total_pagesを計算する際に必要。total_pagesを返すでも可。
    page: page,
    limit: 10, # mock実装の都合上、10に固定。
    results: items_per_page(page)
  }
end

def items_per_page(page)
  case page
  when 1
    (1..10).map { |index| Item.new(index) }
  when 2
    (11..20).map { |index| Item.new(index) }
  when 3
    (21..30).map { |index| Item.new(index) }
  when 4
    (31..33).map { |index| Item.new(index) }
  end
end