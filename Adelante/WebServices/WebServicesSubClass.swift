//
//  WebServicesSubClass.swift
//  Virtuwoof Pet
//
//  Created by EWW80 on 01/11/19.
//  Copyright © 2019 EWW80. All rights reserved.
//

import Foundation
import UIKit
class WebServiceSubClass
{
    //init Api
    class func initApi( strURL : String  ,completion: @escaping CompletionResponse ) {
        WebService.shared.getMethod(url: URL.init(string: strURL)!, httpMethod: .get, completion: completion)
    }
    //Register Api
    class func register( registerModel : RegisterReqModel  ,showHud : Bool = false,completion: @escaping CompletionResponse ) {
        let  params : [String:String] = registerModel.generatPostParams() as! [String : String]
        WebService.shared.requestMethod(api: .Register, httpMethod: .post,showHud: showHud, parameters: params, completion: completion)
    }
    //Login Api
    class func login( loginModel : LoginReqModel  ,showHud : Bool = false,completion: @escaping CompletionResponse ) {
        let  params : [String:String] = loginModel.generatPostParams() as! [String : String]
        WebService.shared.requestMethod(api: .login, httpMethod: .post,showHud: showHud, parameters: params, completion: completion)
    }
    //OTP Send
    class func sendOTP( optModel : sendOtpReqModel  ,showHud : Bool = false,completion: @escaping CompletionResponse ) {
        let  params : [String:String] = optModel.generatPostParams() as! [String : String]
        WebService.shared.requestMethod(api: .sendOtp, httpMethod: .post,showHud: showHud, parameters: params, completion: completion)
    }
    //Edit profile EMail Verify
    class func sendEmail( optModel : sendEmailVerifyReqModel  ,showHud : Bool = false,completion: @escaping CompletionResponse ) {
        let  params : [String:String] = optModel.generatPostParams() as! [String : String]
        WebService.shared.requestMethod(api: .Email_verify, httpMethod: .post,showHud: showHud, parameters: params, completion: completion)
    }
    //Setting
    class func Settings( showHud : Bool = false ,completion: @escaping CompletionResponse ) {
        WebService.shared.getMethod(api: .SettingsLink, parameterString: "", httpMethod: .get, showHud: showHud, completion: completion)
    }
    //Change Password
    class func ChangePassword( changepassModel : ChangePasswordReqModel,showHud : Bool = false  ,completion: @escaping CompletionResponse ) {
        let  params : [String:String] = changepassModel.generatPostParams() as! [String : String]
        WebService.shared.requestMethod(api: .changePassword, httpMethod: .post, parameters: params, completion: completion)
    }
    //Forgot Password Api
    class func ForgotPassword( forgotPassword : ForgotPasswordReqModel  , showHud : Bool = false,completion: @escaping CompletionResponse ) {
        let  params : [String:String] =  forgotPassword.generatPostParams() as! [String : String]
        WebService.shared.requestMethod(api: .ForgotPassword, httpMethod: .post, parameters: params, completion: completion)
    }
    //Update Profile
    class func UpdateProfileInfo( editProfileModel : EditProfileReqModel  ,img : UIImage,isRemoveImage: Bool ,showHud : Bool = false , completion: @escaping CompletionResponse ) {
        let  params : [String:String] = editProfileModel.generatPostParams() as! [String : String]
        WebService.shared.postDataWithImage(api: .EditProfile, isRemoveimage: isRemoveImage, showHud: showHud, parameter: params, image: img, imageParamName: "profile_picture", completion: completion)
    }
    //Logout
    class func Logout( logoutModel : LogoutReqModel ,showHud : Bool = false ,completion: @escaping CompletionResponse ) {
        let  params : [String:String] = logoutModel.generatPostParams() as! [String : String]
        WebService.shared.requestMethod(api: .Logout, httpMethod: .post,showHud: showHud, parameters: params, completion: completion)
    }
    
    //DeleteAccount
    class func deleteAccount( logoutModel : DeleteAccountReqModel ,showHud : Bool = true ,completion: @escaping CompletionResponse ) {
        let  params : [String:String] = logoutModel.generatPostParams() as! [String : String]
        WebService.shared.requestMethod(api: .DeleteAccount, httpMethod: .post,showHud: showHud, parameters: params, completion: completion)
    }
    
    class func deshboard( DashboardModel : DashboardReqModel ,showHud : Bool = false, completion: @escaping CompletionResponse ) {
        let params : [String:String] = DashboardModel.generatPostParams() as! [String:String]
        WebService.shared.requestMethod(api: .Dashboard, httpMethod: .post, showHud: showHud, parameters: params, completion: completion)
    }
    //Profile
    class func profile(strURL : String  ,showHud : Bool = false, completion: @escaping CompletionResponse ) {
        WebService.shared.getMethod(url: URL.init(string: strURL)!, httpMethod: .get, completion: completion)
    }
    //sorting
    class func sorting(showHud : Bool = false, completion: @escaping CompletionResponse ){
//        WebService.shared.getMethod(url: URL.init(string: strURL)!, httpMethod: .get, completion: completion)
        WebService.shared.getMethod(api: .Sorting, parameterString: "", httpMethod: .get, showHud: showHud, completion: completion)
    }
    class func search( Searchmodel : SearchReqModel ,showHud : Bool = false ,completion: @escaping CompletionResponse ) {
        let  params : [String:String] = Searchmodel.generatPostParams() as! [String:String]
        WebService.shared.requestMethod(api: .Search, httpMethod: .post, showHud: showHud, parameters: params, completion: completion)
    }
    class func RestaurantFavorite( RestaurantFavoritemodel : RestaurantFavoriteReqModel ,showHud : Bool = false ,completion: @escaping CompletionResponse ) {
        let  params : [String:String] = RestaurantFavoritemodel.generatPostParams() as! [String:String]
        WebService.shared.requestMethod(api: .FavoriteList, httpMethod: .post, showHud: showHud, parameters: params, completion: completion)
    }
    class func Favorite( Favoritemodel : FavoriteReqModel ,showHud : Bool = false ,completion: @escaping CompletionResponse ) {
        let  params : [String:String] = Favoritemodel.generatPostParams() as! [String:String]
        WebService.shared.requestMethod(api: .favorite, httpMethod: .post, showHud: showHud, parameters: params, completion: completion)
    }
    class func RestaurantList( RestaurantListmodel : RestaurantListReqModel ,showHud : Bool = false ,completion: @escaping CompletionResponse ) {
        let  params : [String:String] = RestaurantListmodel.generatPostParams() as! [String:String]
        WebService.shared.requestMethod(api: .RestaurantList, httpMethod: .post, showHud: showHud, parameters: params, completion: completion)
    }
    class func RestaurantDetails( RestaurantDetailsmodel : RestaurantDetailsReqModel ,showHud : Bool = false ,completion: @escaping CompletionResponse ) {
        let  params : [String:String] = RestaurantDetailsmodel.generatPostParams() as! [String:String]
        WebService.shared.requestMethod(api: .RestaurantDetails, httpMethod: .post, showHud: showHud, parameters: params, completion: completion)
    }
    class func RestaurantVariants( RestaurantVariantsmodel : RestaurantVariantsReqModel,showHud : Bool = false , completion : @escaping CompletionResponse ){
        let params : [String:String] = RestaurantVariantsmodel.generatPostParams() as! [String:String]
        WebService.shared.requestMethod(api: .RestaurantVariants, httpMethod: .post, showHud: showHud, parameters: params, completion: completion)
    }
    class func Feedback( Feedbackmodel : FeedbackReqModel ,showHud : Bool = false ,completion: @escaping CompletionResponse ) {
        let  params : [String:String] = Feedbackmodel.generatPostParams() as! [String:String]
        WebService.shared.requestMethod(api: .Feedback, httpMethod: .post, showHud: showHud, parameters: params, completion: completion)
    }
    class func addCard( addcardsmodel : AddCardReqModel,showHud : Bool = false , completion : @escaping CompletionResponse ){
        let params : [String:String] = addcardsmodel.generatPostParams() as! [String:String]
        WebService.shared.requestMethod(api: .AddCard, httpMethod: .post, showHud: showHud, parameters: params, completion: completion)
    }
    class func addPayment( addpaymentmodel : AddPaymentReqModel,showHud : Bool = false , completion : @escaping CompletionResponse ){
        let params : [String:String] = addpaymentmodel.generatPostParams() as! [String:String]
        WebService.shared.requestMethod(api: .AddPayment, httpMethod: .post, showHud: showHud, parameters: params, completion: completion)
    }
    class func removePaymentList(removePaymentList : AddPaymentDeleteReqModel,showHud : Bool = false,completion : @escaping CompletionResponse){
        let params : [String:String] = removePaymentList.generatPostParams() as! [String:String]
        WebService.shared.requestMethod(api: .RemovePaymentList, httpMethod: .post, showHud: showHud, parameters: params, completion: completion)
    }
    class func removepromocode(removepromocode : removePromocodeReqModel,showHud : Bool = false,completion : @escaping CompletionResponse){
        let params : [String:String] = removepromocode.generatPostParams() as! [String:String]
        WebService.shared.requestMethod(api: .RemovePromocode, httpMethod: .post, showHud: showHud, parameters: params, completion: completion)
    }
    class func orderList(orderListModel: OrderListReqModel,showHud : Bool = false, completion: @escaping CompletionResponse ){
        let params : [String:String] = orderListModel.generatPostParams() as! [String:String]
        WebService.shared.requestMethod(api: .OrderList, httpMethod: .post, showHud: showHud, parameters: params, completion: completion)
    }
    class func orderDetailList( orderDetails : MyorderDetailsReqModel ,showHud : Bool = false ,completion: @escaping CompletionResponse ) {
        let  params : [String:String] = orderDetails.generatPostParams() as! [String:String]
        WebService.shared.requestMethod(api: .OrderDetails, httpMethod: .post, showHud: showHud, parameters: params, completion: completion)
    }
    class func shareorderDetailList( orderDetails : shareorderDetailsReqModel ,showHud : Bool = false ,completion: @escaping CompletionResponse ) {
        let  params : [String:String] = orderDetails.generatPostParams() as! [String:String]
        WebService.shared.requestMethod(api: .shareDetails, httpMethod: .post, showHud: showHud, parameters: params, completion: completion)
    }
    class func RateOrder( rateOrder : RateOrderReqModel ,showHud : Bool = false ,completion: @escaping CompletionResponse ) {
        let  params : [String:String] = rateOrder.generatPostParams() as! [String:String]
        WebService.shared.requestMethod(api: .RateOrder, httpMethod: .post, showHud: showHud, parameters: params, completion: completion)
    }
    class func CancelOrder( cancelOrder : CancelOrderReqModel ,showHud : Bool = false ,completion: @escaping CompletionResponse ) {
        let  params : [String:String] = cancelOrder.generatPostParams() as! [String:String]
        WebService.shared.requestMethod(api: .CancelOrder, httpMethod: .post, showHud: showHud, parameters: params, completion: completion)
    }
    class func ShareOrder( shareOrder : shareOrderReqModel, showHud : Bool = false , completion:@escaping CompletionResponse ){
        let params : [String:String] = shareOrder.generatPostParams() as! [String:String]
        WebService.shared.requestMethod(api: .ShareOrder, httpMethod: .post, showHud: showHud, parameters: params, completion: completion)
    }
    class func RepeatOrder( repeatOrder : RepeatOrderReqModel, showHud : Bool = false , completion:@escaping CompletionResponse ){
        let params : [String:String] = repeatOrder.generatPostParams() as! [String:String]
        WebService.shared.requestMethod(api: .RepeatOrder, httpMethod: .post, showHud: showHud, parameters: params, completion: completion)
    }
    class func AcceptOrder( AcceptOrder : AcceptOrderReqModel, showHud : Bool = false , completion:@escaping CompletionResponse ){
        let params : [String:String] = AcceptOrder.generatPostParams() as! [String:String]
        WebService.shared.requestMethod(api: .Accept, httpMethod: .post, showHud: showHud, parameters: params, completion: completion)
    }
    class func RestaurantOutlet( OutletModel : RestaurantOutletReqModel, showHud : Bool = false , completion:@escaping CompletionResponse ){
        let params : [String:String] = OutletModel.generatPostParams() as! [String:String]
        WebService.shared.requestMethod(api: .Outlets, httpMethod: .post, showHud: showHud, parameters: params, completion: completion)
    }
    class func ReviewList( reviewListModel : ReviewListReqModel, showHud : Bool = false , completion: @escaping CompletionResponse ) {
        let params : [String:String] = reviewListModel.generatPostParams() as! [String:String]
        WebService.shared.requestMethod(api: .ReviewList, httpMethod: .post, showHud: showHud, parameters: params, completion: completion)
    }
    class func NotificationModel( notificationModel : NotificationReqModel,showHud : Bool = false , completion: @escaping CompletionResponse ){
        let params : [String:String] = notificationModel.generatPostParams() as! [String:String]
        WebService.shared.requestMethod(api: .Notification, httpMethod: .post, showHud: showHud, parameters: params, completion: completion)
    }
    //PromoCodeList
    class func PromoCodeList( PromocodeModel : PromocodeListReqModel,showHud : Bool = false , completion: @escaping CompletionResponse ){
        let params : [String:String] = PromocodeModel.generatPostParams() as! [String:String]
        WebService.shared.requestMethod(api: .fetch_promocode, httpMethod: .post, showHud: showHud, parameters: params, completion: completion)
    }
    //ApplyPromoCode
    class func ApplyPromoCode( PromocodeModel : PromocodeApplyReqModel,showHud : Bool = false , completion: @escaping CompletionResponse ){
        let params : [String:String] = PromocodeModel.generatPostParams() as! [String:String]
        WebService.shared.requestMethod(api: .apply_promocode, httpMethod: .post, showHud: showHud, parameters: params, completion: completion)
    }
    //check order
    class func checkOrder( checkOrderModel : checkOrderReqModel,showHud : Bool = false , completion: @escaping CompletionResponse ){
        let params : [String:String] = checkOrderModel.generatPostParams() as! [String:String]
        WebService.shared.requestMethod(api: .checkOrder, httpMethod: .post, showHud: showHud, parameters: params, completion: completion)
    }
    
    class func AddToFoodList( FoodListModel : AddToFoodlistReqModel,showHud : Bool = false , completion: @escaping CompletionResponse  ){
        let params : [String:String] = FoodListModel.generatPostParams() as! [String:String]
        WebService.shared.requestMethod(api: .Add_Foodlist, httpMethod: .post, showHud: showHud, parameters: params, completion: completion)
    }
    
    class func AddToCart( AddToCartModel : AddToCartReqModel,showHud : Bool = false , completion: @escaping CompletionResponse  ){
        let params : [String:String] = AddToCartModel.generatPostParams() as! [String:String]
        WebService.shared.requestMethod(api: .Add_to_Card, httpMethod: .post, showHud: showHud, parameters: params, completion: completion)
    }
    
    class func GetCartDetails( getCartModel : GetCartReqModel,showHud : Bool = false , completion: @escaping CompletionResponse  ){
        let params : [String:String] = getCartModel.generatPostParams() as! [String:String]
        WebService.shared.requestMethod(api: .Get_Card, httpMethod: .post, showHud: showHud, parameters: params, completion: completion)
    }
    
    class func UpdateItemQty( updateQtyModel : UpdateCardQtyReqModel,showHud : Bool = false , completion: @escaping CompletionResponse  ){
        let params : [String:String] = updateQtyModel.generatPostParams() as! [String:String]
        WebService.shared.requestMethod(api: .Update_Cart_Qty, httpMethod: .post, showHud: showHud, parameters: params, completion: completion)
    }
    class func updateParkingList( updateParkingListModel : updateParkingDetailsReqModel,showHud : Bool = false , completion: @escaping CompletionResponse  ){
        let params : [String:String] = updateParkingListModel.generatPostParams() as! [String:String]
        WebService.shared.requestMethod(api: .updateParkingLocation, httpMethod: .post, showHud: showHud, parameters: params, completion: completion)
    }
    
    class func GetFoodList( getFoodlistModel : GetFoodlistReqModel,showHud : Bool = false , completion: @escaping CompletionResponse  ){
        let params : [String:String] = getFoodlistModel.generatPostParams() as! [String:String]
        WebService.shared.requestMethod(api: .Get_Foodlist, httpMethod: .post, showHud: showHud, parameters: params, completion: completion)
    }
    class func itemList(itemListModel : ItemListReqModel,showHud: Bool = false , completion:@escaping CompletionResponse){
        let params : [String:String] = itemListModel.generatPostParams() as! [String:String]
        WebService.shared.requestMethod(api: .ItemList, httpMethod: .post,showHud:showHud,parameters:params,completion:completion)
    }
    class func removeFoodList(removeFoodList : RemoveCartReqModel,showHud : Bool = false,completion : @escaping CompletionResponse){
        let params : [String:String] = removeFoodList.generatPostParams() as! [String:String]
        WebService.shared.requestMethod(api: .clearFoodlist, httpMethod: .post, showHud: showHud, parameters: params, completion: completion)
    }
    class func foodlisttocart( strURL : String  ,completion: @escaping CompletionResponse ) {
        WebService.shared.getMethod(url: URL.init(string: strURL)!, httpMethod: .get, completion: completion)
    }
    class func shareOrderList(shareOrderListModel : shareOrderlistReqModel,showHud: Bool = false , completion:@escaping CompletionResponse){
        let params : [String:String] = shareOrderListModel.generatPostParams() as! [String:String]
        WebService.shared.requestMethod(api: .ShareOrderList, httpMethod: .post,showHud:showHud,parameters:params,completion:completion)
    }
    //Payment
    class func PayNow(ReqModel : PayNowReqModel,showHud: Bool = false , completion:@escaping CompletionResponse){
        let params : [String:String] = ReqModel.generatPostParams() as! [String:String]
        WebService.shared.requestMethod(api: .make_payment, httpMethod: .post,showHud:showHud,parameters:params,completion:completion)
    }
}


