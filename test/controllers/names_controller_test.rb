require 'test_helper'

class NamesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @name = names(:one)
  end

  test "should get index" do
    get names_url, as: :json
    assert_response :success
  end

  test "should create name" do
    assert_difference('Name.count') do
      post names_url, params: { name: { birthYear: @name.birthYear, deathYear: @name.deathYear, knownForTitles: @name.knownForTitles, nconst: @name.nconst, primaryName: @name.primaryName, primaryProfession: @name.primaryProfession } }, as: :json
    end

    assert_response 201
  end

  test "should show name" do
    get name_url(@name), as: :json
    assert_response :success
  end

  test "should update name" do
    patch name_url(@name), params: { name: { birthYear: @name.birthYear, deathYear: @name.deathYear, knownForTitles: @name.knownForTitles, nconst: @name.nconst, primaryName: @name.primaryName, primaryProfession: @name.primaryProfession } }, as: :json
    assert_response 200
  end

  test "should destroy name" do
    assert_difference('Name.count', -1) do
      delete name_url(@name), as: :json
    end

    assert_response 204
  end
end
