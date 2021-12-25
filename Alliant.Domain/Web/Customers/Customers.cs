using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Alliant.Domain
{
    public class Customers : RootEntity
    {
        /// <summary>
        /// Gets or sets CustID
        /// </summary>
        public int CustID
        {
            get; set;
        }

        /// <summary>
        /// Gets or sets CustType
        /// </summary>
        public string CustType
        {
            get; set;
        }

        /// <summary>
        /// Gets or sets CustCode
        /// </summary>
        public string CustCode
        {
            get; set;
        }

        /// <summary>
        /// Gets or sets CustName
        /// </summary>
        public string CustName
        {
            get; set;
        }

        /// <summary>
        /// Gets or sets CustBranchID
        /// </summary>
        public int CustBranchID
        {
            get; set;
        }

        /// <summary>
        /// Gets or sets CustSource
        /// </summary>
        public string CustSource
        {
            get; set;
        }

        /// <summary>
        /// Gets or sets CustSourceDetail
        /// </summary>
        public string CustSourceDetail
        {
            get; set;
        }

        /// <summary>
        /// Gets or sets CustEnteredBy
        /// </summary>
        public int CustEnteredBy
        {
            get; set;
        }

        /// <summary>
        /// Gets or sets CustDateEntered
        /// </summary>
        public DateTime CustDateEntered
        {
            get; set;
        }

        /// <summary>
        /// Gets or sets CustAccountRep
        /// </summary>
        public int CustAccountRep
        {
            get; set;
        }

        /// <summary>
        /// Gets or sets CustWebAddr
        /// </summary>
        public string CustWebAddr
        {
            get; set;
        }

        /// <summary>
        /// Gets or sets CustDiscount
        /// </summary>
        public double CustDiscount
        {
            get; set;
        }

        /// <summary>
        /// Gets or sets CustTerms
        /// </summary>
        public string CustTerms
        {
            get; set;
        }

        /// <summary>
        /// Gets or sets TmpCustId
        /// </summary>
        public string TmpCustId
        {
            get; set;
        }

        /// <summary>
        /// Gets or sets Email
        /// </summary>
        public string Email
        {
            get; set;
        }

        /// <summary>
        /// Gets or sets Password
        /// </summary>
        public string Password
        {
            get; set;
        }

        /// <summary>
        /// Gets or sets LastLogin
        /// </summary>
        public DateTime LastLogin
        {
            get; set;
        }

        /// <summary>
        /// Gets or sets GroupVal
        /// </summary>
        public string GroupVal
        {
            get; set;
        }

        /// <summary>
        /// Gets or sets Natl
        /// </summary>
        public bool Natl
        {
            get; set;
        }

        /// <summary>
        /// Gets or sets CustCreditAmount
        /// </summary>
        public decimal CustCreditAmount
        {
            get; set;
        }

        /// <summary>
        /// Gets or sets OurAccount
        /// </summary>
        public string OurAccount
        {
            get; set;
        }

        /// <summary>
        /// Gets or sets CreditLimit
        /// </summary>
        public int CreditLimit
        {
            get; set;
        }

        /// <summary>
        /// Gets or sets ButtonDirectory
        /// </summary>
        public string ButtonDirectory
        {
            get; set;
        }

        /// <summary>
        /// Gets or sets AllowViewing
        /// </summary>
        public string AllowViewing
        {
            get; set;
        }

        /// <summary>
        /// Gets or sets ResellNo
        /// </summary>
        public string ResellNo
        {
            get; set;
        }

        /// <summary>
        /// Gets or sets CreditApp
        /// </summary>
        public string CreditApp
        {
            get; set;
        }

        /// <summary>
        /// Gets or sets CreditAuth
        /// </summary>
        public string CreditAuth
        {
            get; set;
        }

        /// <summary>
        /// Gets or sets Inactive
        /// </summary>
        public string Inactive
        {
            get; set;
        }

        /// <summary>
        /// Gets or sets OnHold
        /// </summary>
        public string OnHold
        {
            get; set;
        }

        /// <summary>
        /// Gets or sets IsVendor
        /// </summary>
        public string IsVendor
        {
            get; set;
        }

        /// <summary>
        /// Gets or sets VendorOurAccount
        /// </summary>
        public string VendorOurAccount
        {
            get; set;
        }

        /// <summary>
        /// Gets or sets VendorNetTerms
        /// </summary>
        public string VendorNetTerms
        {
            get; set;
        }

        /// <summary>
        /// Gets or sets VendorServicesOffered
        /// </summary>
        public string VendorServicesOffered
        {
            get; set;
        }

        /// <summary>
        /// Gets or sets VendorCreditLimit
        /// </summary>
        public decimal VendorCreditLimit
        {
            get; set;
        }

        /// <summary>
        /// Gets or sets VendorActive
        /// </summary>
        public string VendorActive
        {
            get; set;
        }

        /// <summary>
        /// Gets or sets Vendordiscount
        /// </summary>
        public int Vendordiscount
        {
            get; set;
        }

        /// <summary>
        /// Gets or sets VendorTaxExempt
        /// </summary>
        public string VendorTaxExempt
        {
            get; set;
        }

        /// <summary>
        /// Gets or sets VendorType
        /// </summary>
        public string VendorType
        {
            get; set;
        }

        /// <summary>
        /// Gets or sets CustNotes
        /// </summary>
        public string CustNotes
        {
            get; set;
        }

        /// <summary>
        /// Gets or sets UrgentNotes
        /// </summary>
        public string UrgentNotes
        {
            get; set;
        }

        /// <summary>
        /// Gets or sets Dummy
        /// </summary>
        public string Dummy
        {
            get; set;
        }

        /// <summary>
        /// Gets or sets PasswordExpireOn
        /// </summary>
        public DateTime PasswordExpireOn
        {
            get; set;
        }

        /// <summary>
        /// Gets or sets DonotSendEmail
        /// </summary>
        public bool DonotSendEmail
        {
            get; set;
        }

        /// <summary>
        /// Gets or sets InternalTransfer
        /// </summary>
        public string InternalTransfer
        {
            get; set;
        }

        /// <summary>
        /// Gets or sets Commissionable
        /// </summary>
        public string Commissionable
        {
            get; set;
        }

        /// <summary>
        /// Gets or sets DonotSendEmailDate
        /// </summary>
        public DateTime DonotSendEmailDate
        {
            get; set;
        }

        /// <summary>
        /// Gets or sets LockAccount
        /// </summary>
        public bool LockAccount
        {
            get; set;
        }

        /// <summary>
        /// Gets or sets CustomerReassignmentDate
        /// </summary>
        public DateTime CustomerReassignmentDate
        {
            get; set;
        }

        /// <summary>
        /// Gets or sets CustomerRating
        /// </summary>
        public double CustomerRating
        {
            get; set;
        }

        /// <summary>
        /// Gets or sets OrderFrequency
        /// </summary>
        public string OrderFrequency
        {
            get; set;
        }

        /// <summary>
        /// Gets or sets DoNotSendEmailBy
        /// </summary>
        public string DoNotSendEmailBy
        {
            get; set;
        }

        /// <summary>
        /// Gets or sets DoNotContact
        /// </summary>
        public bool DoNotContact
        {
            get; set;
        }

        /// <summary>
        /// Gets or sets DoNotContactDate
        /// </summary>
        public DateTime DoNotContactDate
        {
            get; set;
        }

        /// <summary>
        /// Gets or sets DoNotContactBy
        /// </summary>
        public string DoNotContactBy
        {
            get; set;
        }

        /// <summary>
        /// Gets or sets ProjectedRevenue
        /// </summary>
        public decimal ProjectedRevenue
        {
            get; set;
        }

        /// <summary>
        /// Gets or sets ProjectedRevenueChangedBy
        /// </summary>
        public int ProjectedRevenueChangedBy
        {
            get; set;
        }

        /// <summary>
        /// Gets or sets ProjectedRevenueChangedOn
        /// </summary>
        public DateTime ProjectedRevenueChangedOn
        {
            get; set;
        }

        /// <summary>
        /// Gets or sets ProjectedRevenuePassed
        /// </summary>
        public bool ProjectedRevenuePassed
        {
            get; set;
        }

        /// <summary>
        /// Gets or sets CustJan
        /// </summary>
        public bool CustJan
        {
            get; set;
        }

        /// <summary>
        /// Gets or sets CustFeb
        /// </summary>
        public bool CustFeb
        {
            get; set;
        }

        /// <summary>
        /// Gets or sets CustMar
        /// </summary>
        public bool CustMar
        {
            get; set;
        }

        /// <summary>
        /// Gets or sets CustApr
        /// </summary>
        public bool CustApr
        {
            get; set;
        }

        /// <summary>
        /// Gets or sets CustMay
        /// </summary>
        public bool CustMay
        {
            get; set;
        }

        /// <summary>
        /// Gets or sets CustJun
        /// </summary>
        public bool CustJun
        {
            get; set;
        }

        /// <summary>
        /// Gets or sets CustJul
        /// </summary>
        public bool CustJul
        {
            get; set;
        }

        /// <summary>
        /// Gets or sets CustAug
        /// </summary>
        public bool CustAug
        {
            get; set;
        }

        /// <summary>
        /// Gets or sets CustSep
        /// </summary>
        public bool CustSep
        {
            get; set;
        }

        /// <summary>
        /// Gets or sets CustOct
        /// </summary>
        public bool CustOct
        {
            get; set;
        }

        /// <summary>
        /// Gets or sets CustNov
        /// </summary>
        public bool CustNov
        {
            get; set;
        }

        /// <summary>
        /// Gets or sets CustDec
        /// </summary>
        public bool CustDec
        {
            get; set;
        }

        //-------------------
        public string AddrStreet
        {
            get;
            set;
        }

        /// <summary>
        /// Gets or sets CustBranchID
        /// </summary>
        public string AddrCity
        {
            get;
            set;
        }

        /// <summary>
        /// Gets or sets CustSource
        /// </summary>
        public string AddrState
        {
            get;
            set;
        }

        /// <summary>
        /// Gets or sets CustSourceDetail
        /// </summary>
        public string AddrZip
        {
            get;
            set;
        }


    }
}
