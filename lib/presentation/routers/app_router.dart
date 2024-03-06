import 'package:dialup_mobile_app/presentation/routers/routes.dart';
import 'package:dialup_mobile_app/presentation/screens/business/basic_company_details/basic_company_details.dart';
import 'package:dialup_mobile_app/presentation/screens/business/index.dart';
import 'package:dialup_mobile_app/presentation/screens/business/loans/loan_statement.dart';
import 'package:dialup_mobile_app/presentation/screens/common/explore/index.dart';
import 'package:dialup_mobile_app/presentation/screens/common/index.dart';
import 'package:dialup_mobile_app/presentation/screens/common/select_entity_for_persistent_onboarding.dart';
import 'package:dialup_mobile_app/presentation/screens/retail/accountDetails/index.dart';
import 'package:dialup_mobile_app/presentation/screens/retail/application/index.dart';
import 'package:dialup_mobile_app/presentation/screens/retail/cardsVault/index.dart';
import 'package:dialup_mobile_app/presentation/screens/retail/dashboard.dart';
import 'package:dialup_mobile_app/presentation/screens/retail/deposits/index.dart';
import 'package:dialup_mobile_app/presentation/screens/retail/dormant/dormant.dart';
import 'package:dialup_mobile_app/presentation/screens/retail/explore.dart';
import 'package:dialup_mobile_app/presentation/screens/retail/insights.dart';
import 'package:dialup_mobile_app/presentation/screens/retail/notifications/notifications.dart';
import 'package:dialup_mobile_app/presentation/screens/retail/onboardingStatus/onboarding_status.dart';
import 'package:dialup_mobile_app/presentation/screens/retail/pending_status.dart';
import 'package:dialup_mobile_app/presentation/screens/retail/profile/index.dart';
import 'package:dialup_mobile_app/presentation/screens/retail/accept_terms_and_conditions.dart';
import 'package:dialup_mobile_app/presentation/screens/retail/transfer/index.dart';
import 'package:dialup_mobile_app/presentation/screens/retail/verification/face_compare.dart';
import 'package:dialup_mobile_app/presentation/screens/retail/verification/index.dart';
import 'package:flutter/material.dart';

class AppRouter {
  Route onGenerateRoute(RouteSettings routeSettings) {
    final args = routeSettings.arguments;
    switch (routeSettings.name) {
      case Routes.splash:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );
      case Routes.onboarding:
        return MaterialPageRoute(
          builder: (_) => OnboardingScreen(
            argument: args,
          ),
        );
      case Routes.exploreDashboard:
        return MaterialPageRoute(
          builder: (_) => const ExploreDashboardScreen(),
        );
      case Routes.exploreSendMoney:
        return MaterialPageRoute(
          builder: (_) => const ExploreSendMoneyScreen(),
        );
      case Routes.registration:
        return MaterialPageRoute(
          builder: (_) => RegistrationScreen(
            argument: args,
          ),
        );
      // case Routes.login:
      //   return MaterialPageRoute(
      //     builder: (_) => const LoginScreen(), // ! Deprecated
      //   );
      case Routes.loginUserId:
        return MaterialPageRoute(
          builder: (_) => const LoginUserIdScreen(),
        );
      case Routes.loginPassword:
        return MaterialPageRoute(
          builder: (_) => LoginPasswordScreen(
            argument: args,
          ),
        );
      case Routes.loginBiometric:
        return MaterialPageRoute(
          builder: (_) => LoginBiometricScreen(
            argument: args,
          ),
        );
      case Routes.selectAccountType:
        return MaterialPageRoute(
          builder: (_) => SelectAccountTypeScreen(
            argument: args,
          ),
        );
      case Routes.notAvailable:
        return MaterialPageRoute(
          builder: (_) => NotAvaiableScreen(
            argument: args,
          ),
        );
      case Routes.otp:
        return MaterialPageRoute(
          builder: (_) => OTPScreen(
            argument: args,
          ),
        );
      case Routes.createPassword:
        return MaterialPageRoute(
          builder: (_) => CreatePasswordScreen(
            argument: args,
          ),
        );
      case Routes.retailOnboardingStatus:
        return MaterialPageRoute(
          builder: (_) => RetailOnboardingStatusScreen(
            argument: args,
          ),
        );
      case Routes.exploreAccountDetails:
        return MaterialPageRoute(
          builder: (_) => const ExploreAccountDetailsScreen(),
        );
      case Routes.exploreCreateDeposit:
        return MaterialPageRoute(
          builder: (_) => const ExploreCreateDepositScreen(),
        );
      case Routes.verificationInitializing:
        return MaterialPageRoute(
          builder: (_) => VerificationInitializingScreen(
            argument: args,
          ),
        );
      case Routes.eidExplanation:
        return MaterialPageRoute(
          builder: (_) => EIDExplanationScreen(
            argument: args,
          ),
        );
      case Routes.passportExplanation:
        return MaterialPageRoute(
          builder: (_) => PassportExplanationScreen(
            argument: args,
          ),
        );
      case Routes.scannedDetails:
        return MaterialPageRoute(
          builder: (_) => ScannedDetailsScreen(
            argument: args,
          ),
        );
      case Routes.faceCompare:
        return MaterialPageRoute(
          builder: (_) => FaceCompareScreen(
            argument: args,
          ),
        );
      case Routes.businessOnboardingStatus:
        return MaterialPageRoute(
          builder: (_) => BusinessOnboardingStatusScreen(
            argument: args,
          ),
        );
      case Routes.basicCompanyDetails:
        return MaterialPageRoute(
          builder: (_) => const BasicCompanyDetailsScreen(),
        );
      // case Routes.captureFace:
      //   return MaterialPageRoute(
      //     builder: (_) => const CaptureFaceScreen(), // Deprecated
      //   );
      // case Routes.finalImage:
      //   return MaterialPageRoute(
      //     builder: (_) => FinalFaceImageScreen( // Deprecated
      //       argument: args,
      //     ),
      //   );
      case Routes.retailDashboard:
        return MaterialPageRoute(
          builder: (_) => RetailDashboardScreen(
            argument: args,
          ),
        );
      case Routes.businessDashboard:
        return MaterialPageRoute(
          builder: (_) => BusinessDashboardScreen(
            argument: args,
          ),
        );
      case Routes.profileUpdatePassword:
        return MaterialPageRoute(
          builder: (_) => ProfileDetailsPasswordScreen(
            argument: args,
          ),
        );
      case Routes.verifyMobile:
        return MaterialPageRoute(
          builder: (_) => VerifyMobileScreen(
            argument: args,
          ),
        );
      case Routes.thankYou:
        return MaterialPageRoute(
          builder: (_) => const ThankYouScreen(),
        );
      case Routes.request:
        return MaterialPageRoute(
          builder: (_) => const RequestScreen(),
        );

      case Routes.loanDetails:
        return MaterialPageRoute(
          builder: (_) => LoanDetailsScreen(
            argument: args,
          ),
        );
      case Routes.applicationAddress:
        return MaterialPageRoute(
          builder: (_) => const ApplicationAddressScreen(),
        );
      case Routes.applicationIncome:
        return MaterialPageRoute(
          builder: (_) => const ApplicationIncomeScreen(),
        );
      case Routes.applicationTaxFATCA:
        return MaterialPageRoute(
          builder: (_) => const ApplicationTaxFATCAScreen(),
        );
      case Routes.applicationTaxCRS:
        return MaterialPageRoute(
          builder: (_) => ApplicationTaxCRSScreen(
            argument: args,
          ),
        );
      case Routes.applicationAccount:
        return MaterialPageRoute(
          builder: (_) => ApplicationAccountScreen(
            argument: args,
          ),
        );
      case Routes.acceptTermsAndConditions:
        return MaterialPageRoute(
          builder: (_) => AcceptTermsAndConditionsScreen(
            argument: args,
          ),
        );
      case Routes.errorSuccessScreen:
        return MaterialPageRoute(
          builder: (_) => ErrorSuccessScreen(
            argument: args,
          ),
        );
      case Routes.interestRates:
        return MaterialPageRoute(
          builder: (_) => const InterestRatesScreen(),
        );
      case Routes.createDeposits:
        return MaterialPageRoute(
          builder: (_) => CreateDepositsScreen(
            argument: args,
          ),
        );
      case Routes.depositConfirmation:
        return MaterialPageRoute(
          builder: (_) => DepositConfirmationScreen(argument: args),
        );
      case Routes.depositDetails:
        return MaterialPageRoute(
          builder: (_) => DepositDetailsScreen(
            argument: args,
          ),
        );
      case Routes.prematureWithdrawal:
        return MaterialPageRoute(
          builder: (_) => PrematureWithdrawalScreen(
            argument: args,
          ),
        );
      case Routes.depositStatement:
        return MaterialPageRoute(
          builder: (_) => const DepositStatementScreen(),
        );
      case Routes.insights:
        return MaterialPageRoute(
          builder: (_) => const InsightsScreen(),
        );
      case Routes.transferDetails:
        return MaterialPageRoute(
          builder: (_) => TransferDetailsScreen(
            argument: args,
          ),
        );
      case Routes.walletDetails:
        return MaterialPageRoute(
          builder: (_) => AddWalletDetailsScreen(
            argument: args,
          ),
        );
      case Routes.sendMoney:
        return MaterialPageRoute(
          builder: (_) => SendMoneyScreen(
            argument: args,
          ),
        );
      case Routes.sendMoneyFrom:
        return MaterialPageRoute(
          builder: (_) => SendMoneyFromScreen(
            argument: args,
          ),
        );
      case Routes.sendMoneyTo:
        return MaterialPageRoute(
          builder: (_) => SendMoneyToScreen(
            argument: args,
          ),
        );
      case Routes.transferConfirmation:
        return MaterialPageRoute(
          builder: (_) => TransferConfirmationScreen(
            argument: args,
          ),
        );
      case Routes.transferAmount:
        return MaterialPageRoute(
          builder: (_) => TransferAmountScreen(
            argument: args,
          ),
        );
      case Routes.selectRecipient:
        return MaterialPageRoute(
          builder: (_) => SelectRecipientScreen(
            argument: args,
          ),
        );
      case Routes.recipientDetails:
        return MaterialPageRoute(
          builder: (_) => RecipientDetailsScreen(
            argument: args,
          ),
        );
      case Routes.selectCountry:
        return MaterialPageRoute(
          builder: (_) => SelectCountryScreen(
            argument: args,
          ),
        );
      case Routes.recipientReceiveMode:
        return MaterialPageRoute(
          builder: (_) => RecipientReceiveModeScreen(
            argument: args,
          ),
        );
      case Routes.addRecipDetRem:
        return MaterialPageRoute(
          builder: (_) => AddRecipientDetailsRemittanceScreen(
            argument: args,
          ),
        );
      case Routes.addRecipDetUae:
        return MaterialPageRoute(
          builder: (_) => const AddRecipientDetailsUaeScreen(),
        );
      case Routes.depositBeneficiary:
        return MaterialPageRoute(
          builder: (_) => DepositBeneficiaryScreen(
            argument: args,
          ),
        );
      case Routes.password:
        return MaterialPageRoute(
          builder: (_) => PasswordScreen(
            argument: args,
          ),
        );
      case Routes.downloadStatement:
        return MaterialPageRoute(
          builder: (_) => DownloadStatementScreen(
            argument: args,
          ),
        );
      case Routes.vault:
        return MaterialPageRoute(
          builder: (_) => const VaultScreen(),
        );
      case Routes.referralCode:
        return MaterialPageRoute(
          builder: (_) => const AskReferralCode(),
        );
      case Routes.actions:
        return MaterialPageRoute(
          builder: (_) => const ActionsScreen(),
        );
      case Routes.pendingStatus:
        return MaterialPageRoute(
          builder: (_) => const PendingStatusScreen(),
        );
      case Routes.profileHome:
        return MaterialPageRoute(
          builder: (_) => ProfileHomeScreen(
            argument: args,
          ),
        );

      case Routes.profile:
        return MaterialPageRoute(
          builder: (_) => ProfileScreen(
            argument: args,
          ),
        );
      case Routes.selectAccount:
        return MaterialPageRoute(
          builder: (_) => SelectAccountScreen(
            argument: args,
          ),
        );
      case Routes.security:
        return MaterialPageRoute(
          builder: (_) => SecurityScreen(
            argument: args,
          ),
        );
      case Routes.changePassword:
        return MaterialPageRoute(
          builder: (_) => const ChangePassword(),
        );
      case Routes.faq:
        return MaterialPageRoute(
          builder: (_) => const FaqScreen(),
        );
      case Routes.requestType:
        return MaterialPageRoute(
          builder: (_) => const RequestTypeScreen(),
        );
      case Routes.updateAddress:
        return MaterialPageRoute(
          builder: (_) => UpdateAddressScreen(
            argument: args,
          ),
        );
      case Routes.notifications:
        return MaterialPageRoute(
          builder: (_) => const NotificatonsScreen(),
        );
      case Routes.workflowDetails:
        return MaterialPageRoute(
          builder: (_) => WorkflowDetailsScreen(
            argument: args,
          ),
        );
      case Routes.accountDetails:
        return MaterialPageRoute(
          builder: (_) => AccountDetailsScreen(
            argument: args,
          ),
        );
      case Routes.exploreBusiness:
        return MaterialPageRoute(
          builder: (_) => const BusinessExploreScreen(),
        );
      case Routes.exploreRetail:
        return MaterialPageRoute(
          builder: (_) => const RetailExploreScreen(),
        );
      case Routes.termsAndConditions:
        return MaterialPageRoute(
          builder: (_) => const TermsAndConsitionsScreen(),
        );
      case Routes.privacyStatement:
        return MaterialPageRoute(
          builder: (_) => const PrivacyStatementScreen(),
        );
      case Routes.setPassword:
        return MaterialPageRoute(
          builder: (_) => SetPasswordScreen(
            argument: args,
          ),
        );
      case Routes.dormant:
        return MaterialPageRoute(
          builder: (_) => const DormantScreen(),
        );
      case Routes.entityForOnboarding:
        return MaterialPageRoute(
          builder: (_) => const SelectEntityForOnboardingPersistence(),
        );
      case Routes.inviteFriends:
        return MaterialPageRoute(
          builder: (_) => const InviteFriendsScreen(),
        );
      case Routes.loanStatement:
        return MaterialPageRoute(
          builder: (_) => LoanDownloadStatementScreen(
            argument: args,
          ),
        );
      case Routes.recipientType:
        return MaterialPageRoute(
          builder: (_) => SelectRecipientTypeScreen(
            argument: args,
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text("Empty Screen"),
            ),
          ),
        );
    }
  }
}
