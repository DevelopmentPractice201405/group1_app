class API < Grape::API
    format :json
    default_format :json
    # http://hoge.com/api
    prefix "api"
    # http://hoge.com/api/v1
    version "v1", using: :path

    resource "microposts" do
        desc "マイクロポストの一覧を返す"
        get do
            Micropost.all
        end

        desc "指定したidのマイクロポストを返す"
        params do
            requires :id, type: Integer
        end
        get ":id" do
            Micropost.find(params[:id])
        end
    end

    resource "users" do
        desc "ユーザー一覧を返す"
        get do
            User.all
        end

        desc "指定したidのユーザーを返す"
        params do
            requires :id, type: Integer
        end
        get ":id" do
            User.find(params[:id])
        end
    end
end
