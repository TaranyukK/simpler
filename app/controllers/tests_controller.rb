class TestsController < Simpler::Controller
  def index
    @tests = Test.all
  end

  def show
    @test = Test.find(id: params[:id])
  end

  def create; end
end
