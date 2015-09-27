require 'test_helper'

class ProjectsControllerTest < ActionController::TestCase
  setup do
    @project = projects(:rethink)

    authenticate
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:projects)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create project" do
    assert_difference('Project.count') do
      post :create, project: { release_at: Date.today, description: "Fantastic project", minimum_team_number: 5, title: "Eureka", license_id: 4, home_url: "http://myurl.org/", source_code_url: "http://myurl.org/src", documentation_url: "http://myurl.org/doc" }
    end

    assert_redirected_to project_path(assigns(:project))
  end

  test "should show project" do
    get :show, id: @project
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @project
    assert_response :success
  end

  test "should update project" do
    patch :update, id: @project, project: { release_at: @project.release_at, description: @project.description, minimum_team_number: @project.minimum_team_number, title: @project.title, license_id: @project.license_id }
    assert_redirected_to project_path(assigns(:project))
  end

  test "should destroy project" do
    assert_difference('Project.count', -1) do
      delete :destroy, id: @project
    end

    assert_redirected_to projects_path
  end

  test "should check minimum team number of 2" do
    assert_no_difference('Project.count') do
      post :create, project: { release_at: Date.today, description: "Fantastic project", minimum_team_number: 0, title: "Eureka", license_id: 4 }
    end
  end

  test "should check value's correctness of minimum team number" do
    assert_no_difference('Project.count') do
      post :create, project: { release_at: Date.today, description: "Fantastic project", minimum_team_number: 1.4, title: "Eureka", license_id: 4 }
    end
  end

  test "should check length of title between 2 and 60" do
    assert_no_difference('Project.count') do
      post :create, project: { release_at: Date.today, description: "My beautifull project", minimum_team_number: 3, title: "A", license_id: 4 }
    end

    too_long_title = random_string(61)

    assert_no_difference('Project.count') do
      post :create, project: { release_at: Date.today, description: "My beautifull project", minimum_team_number: 3, title: too_long_title, license_id: 4 }
    end
  end

  test "should check uniqueness of title" do
    assert_no_difference('Project.count') do
      post :create, project: { release_at: @project.release_at, description: @project.description, minimum_team_number: @project.minimum_team_number, title: @project.title, license_id: @project.license_id }
    end
  end

  test "should check length of description between 2 and 1600" do
    assert_no_difference('Project.count') do
      post :create, project: { release_at: Date.today, description: "", minimum_team_number: 3, title: "Eureka", license_id: 4 }
    end

    too_long_string = random_string(1601)

    assert_no_difference('Project.count') do
      post :create, project: { release_at: Date.today, description: too_long_string, minimum_team_number: 3, title: "Eureka", license_id: 4 }
    end
  end

  # test "should check a project that cannot be created in the past" do
  #   assert_no_difference('Project.count') do
  #     post :create, project: { release_at: Date.yesterday, description: "Fantastic outdated project", minimum_team_number: 3, title: "Eureka", license_id: 4 }
  #   end
  # end
end
