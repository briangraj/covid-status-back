require "test_helper"

# TODO parameterize route and expect values to avoid having duplicate tests
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

  test "GET /covid/total should filter by gender" do
    total_count = Case.where(gender: "M").count

    get(covid_total_path + "?gender=M")
    response = JSON.parse @response.body

    assert_equal total_count, response["count"]
  end

  test "GET /covid/total should filter by age_from" do
    total_count = Case.age_from(30).count

    get(covid_total_path + "?age_from=30")
    response = JSON.parse @response.body

    assert_equal total_count, response["count"]
  end

  test "GET /covid/total should filter by age_to" do
    total_count = Case.age_to(25).count

    get(covid_total_path + "?age_to=25")
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

  test "GET /covid/deaths should filter by gender" do
    deaths_count = Case.where.not(death_date: nil)
                       .where(gender: "M")
                       .count

    get(covid_deaths_path + "?gender=M")
    response = JSON.parse @response.body

    assert_equal deaths_count, response["count"]
  end

  test "GET /covid/deaths should filter by age_from" do
    deaths_count = Case.where.not(death_date: nil)
                       .age_from(30)
                       .count

    get(covid_deaths_path + "?age_from=30")
    response = JSON.parse @response.body

    assert_equal deaths_count, response["count"]
  end

  test "GET /covid/deaths should filter by age_to" do
    deaths_count = Case.where.not(death_date: nil)
                       .age_to(25)
                       .count

    get(covid_deaths_path + "?age_to=25")
    response = JSON.parse @response.body

    assert_equal deaths_count, response["count"]
  end
end
