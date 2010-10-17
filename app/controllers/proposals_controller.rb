class ProposalsController < ApplicationController
  before_filter :authenticate_user!, :only => [:create, :new, :update, :destroy, :edit, :dislike, :like]
  before_filter :event

  # GET /proposals
  # GET /proposals.xml
  def index
    @proposals = Proposal.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @proposals }
    end
  end

  # GET /proposals/1
  # GET /proposals/1.xml
  def show
    @comments = proposal.comments.order("created_at DESC")

    @comment = Comment.new
    @comment.proposal = proposal

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @proposal }
    end
  end

  # GET /proposals/new
  # GET /proposals/new.xml
  def new
    @proposal = Proposal.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @proposal }
    end
  end

  # GET /proposals/1/edit
  def edit
    proposal
  end

  # POST /proposals
  # POST /proposals.xml
  def create
    @proposal = Proposal.new(params[:proposal])
    @proposal.user = current_user
    @proposal.event = event

    respond_to do |format|
      if @proposal.save
        format.html { redirect_to(@event, :notice => 'Proposal was successfully created.') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /proposals/1
  # PUT /proposals/1.xml
  def update
    respond_to do |format|
      if proposal.update_attributes(params[:proposal])
        format.html { redirect_to(@proposal, :notice => 'Proposal was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @proposal.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /proposals/1
  # DELETE /proposals/1.xml
  def destroy
    proposal.destroy

    respond_to do |format|
      format.html { redirect_to(proposals_url) }
      format.xml  { head :ok }
    end
  end

  def like
    Vote.like!(proposal, current_user)
    respond_to do |format|
        format.html { render proposal, :layout => false }
    end
  end

  def dislike
    Vote.dislike!(proposal, current_user)
    respond_to do |format|
        format.html { render proposal, :layout => false }
    end
  end

  private
  def event
    @event ||= Event.find params[:event_id]
  end

  def proposal
    @proposal ||= Proposal.find(params[:id])
  end
end
