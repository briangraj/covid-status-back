require "test_helper"

class StatFlowsTest < ActionDispatch::IntegrationTest
    test "GET /covid/total is recognized" do
      assert_recognizes(
        { controller: "stats", action: "total" },
        { path: "covid/total", method: :get }
      )
    end

    test "GET /covid/total responds 200" do
      get covid_total_path

      assert_response :ok
    end

    test "GET /covid/total responds a number" do
      total_count = Case.count

      get covid_total_path
      response = JSON.parse @response.body

      assert_equal total_count, response["count"]
    end

    test "GET /covid/deaths is recognized" do
      assert_recognizes(
        { controller: "stats", action: "deaths" },
        { path: "covid/deaths", method: :get }
      )
    end

    test "GET /covid/deaths responds 200" do
      get covid_deaths_path

      assert_response :ok
    end

    test "GET /covid/deaths responds a number" do
      deaths_count = Case.where.not(death_date: nil).count

      get covid_deaths_path
      response = JSON.parse @response.body

      assert_equal deaths_count, response["count"]
    end
end
