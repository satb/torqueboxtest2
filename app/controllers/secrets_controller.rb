class SecretsController < ApplicationController
  def new
    logger.warn "session=" + session.to_s
  end
end
