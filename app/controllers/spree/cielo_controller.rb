class Spree::CieloController < Spree::BaseController
  def return
    payment = Spree::Payment.by_order(params[:payment_id], params[:order_number]).first
    if payment
      payment.source.capture payment
      if payment.reload.completed?
        redirect_to order_path(payment.order), :notice => t(:order_processed_successfully)
      else
        payment.source.retry_capture(payment)
        redirect_to order_path(payment.order), :alert => t(:payment_not_identified)
      end
    else
      redirect_to root_path, :alert => t(:order_not_found)
    end
  end
end