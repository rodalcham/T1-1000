// LTeX: enabled=false
#import "template.typ": caption_with_source, project
#import "utils.typ": codefigure, codefigurefile

#show: project.with(
  // 'de' for german or 'en' for english.
  // Pull Requests for other languages are welcome! :)
  lang: "en",

  // Shows a line for a signature, if set to `false`,
  is_digital: true,

  // Display the confidentiality clause
  confidentiality_clause: true,

  ///
  /// Cover Sheet
  ///
  // Full title of your project
  title_long: "Output Filtering for Financial Asset Valuation Transactions: Technical Implementation",
  // Shortened title, which is displayed in the header on every page
  title_short: "Output Filtering for Financial Asset Valuation",
  // The type of your project
  thesis_type: "Projektarbeit 1 (T1000)",
  // Other information about you and your project
  authors: (
    (
      firstname: "Rodrigo",
      lastname: "Chavez",
      matriculation_number: "7643646",
      course: "TINFO25",
    ), // make sure to keep this comma after the first author if there is only one author!
    // (
    //   firstname: "Erika",
    //   lastname: "Musterfrau",
    //   matriculation_number: "1234567",
    //   course: "TINF23B1"
    // )
  ),
  signature_place: "Mosbach",
  submission_date: "31. März 2023",
  processing_period: "01.01.2023 - 31.03.2023",
  // Commenting out the line below removes the department from the title page
  department: "ERP PCE FIN&RISK ROT 7",
  supervisor_company: "Milena Schmidt",
  supervisor_university: "-",

  // Disable the abstract by changing to `abstract: ()`
  // To load the abstract from a file use include("abstract.typ") instead of [...]`
  // If you only want one language, leave the comma at the end -> `("de", "Deutsch", []),` its necessary for syntax of the template
  abstract: (
    ("en", "English", include "abstracts/abstract_english.typ"),
  ),

  // appendices: usage: ("Title", [content] || include("appendix.typ"))
  // change to `appendices: none` to remove appendix
  appendices: (
    // ("Appendix Titel 1", include("appendix.typ")), // appendix from file
    (
      "Titel 1",
      [
        == This is some more source code
        #lorem(10)
      ],
    ), // appendix inline
    (
      "Titel 2",
      [
        == Even more!
        #lorem(50)
      ],
    ),
  ),

  // Path/s to references - either .yaml or .bib files
  // * for `.yaml` files see: [hayagriva](https://github.com/typst/hayagriva)
  library_paths: "references.yaml",

  // Specify acronyms here.
  // The key is used to reference the acronym.
  // The short form is used every time and the long form is used
  // additionally the first time you reference the acronym.
  acronyms: (
    (key: "SAP", short: "SAP SE", long: " Systems, Applications & Products in Data Processing"),
    (key: "TRM", short: "TRM", long: "Treasury and Risk Management"),
		(key: "OTC", short: "OTC", long: "Over The Counter"),
  ),
)

// LTeX: enabled=true

= Introduction
= Definitions
First, it is necessary to clarify the meaning of certain terms that will be used throughout this paper. This chapter aims to provide clear definitions of both global financial terminology and SAP-specific concepts.
== SAP Treasury and Risk Management (SAP TRM)
Along the scope of this paper, we will work with SAP software that belongs to the Treasury and Risk Management application. According to SAP, Treasury and Risk Management (TRM) is a solution designed to support the management and mitigation of financial risks, including liquidity risk, foreign exchange risk, counterparty risk, and other market-related risks. It enables precise recording of financial activities and provides an integrated overview of all business transactions in compliance with international accounting standards such as IFRS and US GAAP.@Trm

The following figure details the scope of the TRM application, its functional areas, and business processes.

#figure(
	image("assets/TRM.png"),
	caption: "TRM"
)

In the scope of this paper we will be working on the Period-End Closing part of this program, which belongs to Treasury Accounting, in the Transaction and Position Management functional area.
// === Transaction Management
// === Position Management
// ==== Position
== Financial Transactions
Throughout this paper, we examine components of SAP software that handle various types of financial transactions. Within the context of TRM, SAP defines a financial transaction as a contract which purpose is to invest or borrow funds, or to mitigate existing financial risks.@Terms In particular, the transactions relevant to this paper deal with the valuation of securities, loans, listed derivatives, and OTC transactions. Detailed definitions of these financial terms are not required for understanding the scope of this paper and are therefore omitted.
// === Securities
// === Loans
// === Listed Derivatives
// === OTC Transactions
== Valuation
According to the Corporate Finance Institute, a valuation is the process of determining the worth of a company, investment, or asset by analyzing future cash flows, financial statements, and other relevant indicators. Unlike the current market value of an asset, a valuation focuses on intrinsic value rather than cost or prevailing trading price.@Valuation
== Valuation Processes in SAP TRM
In the TRM software, two transactions manage the valuation of financial transactions. These are the Run Valuation and Reverse Valuation transactions, or TPM1 and TPM2 respectively. These are the transactions we will focus on for this technical implementation. 
=== Run Valuation (TPM1)
This transaction performs a key date valuation of selected treasury positions. It enables the selection of treasury positions using various criteria, values them as of a specified key date according to defined valuation procedures, recalculates book values, and posts the resulting valuation effects to Financial Accounting @Tpm1

The following figure shows the selection screen corresponding to the Run Valuation transaction in the TRM application.

#figure(
	image("assets/TPM1_screen.png", width: 88%),
	caption: "Snapshot of TPM1 screen"
)

=== Reverse Valuation (TPM2)
This transaction reverses a previously executed key date valuation of selected treasury positions. It enables the selection of treasury positions using various criteria, reverses the posted valuation and reset flows as of a specified valuation date, and updates Financial Accounting accordingly.@Tpm2

The following figure shows the selection screen corresponding to the Reverse Valuation transaction in the TRM application.

#figure(
	image("assets/TPM2_screen.png", width: 88%),
	caption: "Snapshot of TPM2 screen"
)

= Business Value

This chapter presents the identified problem, the proposed solution, the methodology employed for its implementation, and the anticipated value generated by this enhancement.

== Problematic
Prior to the enhancements implemented during the development of this paper, the output of TPM1 and TPM2 had no filtering options. As a result, the log contained warnings, success, and error messages all mixed together, which also led to long spool rendering times. In some cases, the generated logs contained thousands of messages, requiring users to manually review them to ensure the reliability of the system. In subsequent chapters, a figure will present the output of a test scenario both with and without filtering, demonstrating the impact of the proposed solution.

== Proposed Solutions
To address this issue, the proposed solution is to implement a filtering selection screen in a separate, reusable include file, together with transaction-specific filtering logic. This approach allows users to control which messages are displayed at the end of the transaction, giving them the option to view only errors, errors and warnings, or all messages. This should allow users to clearly identify the positions that may require further remediation, without unnecessarily drawing attention to those that were successfully processed. In addition, reducing the number of messages to be displayed significantly decreases spool rendering time, shortening the overall execution time for the transaction. Implementing this solution in a centralized manner allows the same filtering logic to be reused across both the TPM1 and TPM2 transactions. The solution must follow the established design patterns and conventions used by similar implementations within the application, to ensure code quality, usability, and long-term maintainability.
== Method
To achieve this within the available timeframe of approximately eight weeks, it is necessary to carefully plan each stage of the process. Therefore, the proposed schedule distributes the time as follows.

The first week will be dedicated to acquiring the foundational knowledge required for development. This includes understanding the necessary financial concepts involved, as well as developing the ABAP skills required to implement the proposed enhancements.

The subsequent two weeks will be used to become familiar with the structure of the system and the logic governing the flow of information within both transactions, as well as reviewing similar solutions implemented elsewhere in the application.

The fourth and fifth weeks will focus on implementing the proposed enhancements, ensuring all quality standards are met.

Week six will be allocated to gathering feedback on the implemented changes and incorporating any suggested improvements. 

The seventh week will be dedicated to documentation, deployment, and addressing any issues that may arise during this process.

Finally, the eighth and last week will be reserved for writing this paper and resolving any potential issues that may arise after deployment.

Following this schedule should provide sufficient time to develop a comprehensive understanding of the problem, implement the required enhancements, complete all necessary deployment steps, and adequately address any unforeseen challenges. The following figure summarizes this timeline.

#figure(
	image("assets/Timeline.png"),
	caption: "Proposed timeline"
)

== Projected Value

The implementation of selective log filtering in TPM1 and TPM2 is expected to deliver performance benefits, and a better user experience. By enabling users to focus only on relevant error or warning messages, the time required to review transaction logs will be reduced, improving efficiency and minimizing the risk of overlooking critical issues.
The reduction in the number of messages displayed also decreases spool rendering times, shortening the overall execution of the transactions.
Furthermore, by implementing the solution in a centralized and consistent manner, the system maintains alignment with established design patterns, supporting long-term maintainability and reducing the effort required for future enhancements.
Collectively, these improvements enhance system reliability, reduce user workload, and provide a clear, measurable return on investment in both time and a reduced risk of overlooking errors.


= Transaction Flow

This chapter aims to provide a low-level explanation of the logic underlying the TPM1 and TPM2 transactions. A basic understanding of this logic is essential for comprehending and implementing the enhancements presented in this paper.

== Run Valuation (TPM1) and Reverse Valuation (TPM2)

Both transactions share a significant portion of their processing logic. In practice, they route execution through the same core functions, where conditional statements determine the subsequent processing steps based on the context. This shared structure forms the foundation upon which the proposed enhancements are built. This shared architecture becomes apparent when analyzing the following code extracts from TPM1 and TPM2.

#codefigurefile(
	"assets/tpm1_main.typ",
	caption: "TPM1 extract",
	lang: "ABAP"
)
#codefigurefile(
	"assets/tpm2_main.typ",
	caption: "TPM2 extract",
	lang: "ABAP"
)

In both transactions, multiple parameters are set into a *pselection* object of class *cl_selection_tlv*; this object is then passed to a *pworkingstock* object of class *cl_workingstock_tlv*, where position processing takes place. Two aspects of these extracts warrant particular attention. First, the opening line of both extracts sets the posting mode, which subsequently differentiates the logic for each transaction. Second, the final line calls the same function in both cases to handle position processing. This centralized logic is where we will implement the proposed enhancements.
#linebreak()

The following extract shows the process method of class *cl_workingstock_tlv*, previously called by both transactions. This method contains the main logic governing the behavior of both TPM1 and TPM2.

Analyzing this method reveals that, at this level of abstraction, both transactions follow identical execution paths. The process is divided into separate methods for position processing and output display. This separation is significant because it provides an opportunity to insert the proposed filtering solution between these two steps, avoiding unnecessary modifications to the pre-existing processing methods. 
While filtering at a deeper layer of abstraction would be more resource-efficient, it would require propagating filtering variables deeper into the program structure, thereby necessitating more extensive system modifications.

#pagebreak()

#codefigurefile(
	"assets/process_old.typ",
	caption: "Process method, extracted from cl_workingstock_tlv",
	lang: "ABAP"
)

For further clarity, the following figure depicts a visual representation of this method. The blank squares, labeled with question marks, represent where the proposed changes would be integrated.

#figure(
	image("assets/process_graph.pdf", width: 91%),
	caption: "Logic of Process method, simplified"
)

== Differentiation

While both transactions follow similar flows at high levels of abstraction, they perform fundamentally different operations.

This differentiation occurs within the methods called by the Process method, or at even deeper levels of the call stack. It is, therefore, irrelevant to our development process because of the deliberate decision to implement the proposed enhancements in a centralized manner, at a high abstraction level. That is to say, the divergent logic at lower levels will not affect the proposed enhancements. 

In the following extract, a simplified representation allows us to observe how the logic for each transaction is separated in methods at deeper levels of the call stack.
#codefigurefile(
	"assets/posting_mode.typ",
	caption: "Example of variation between TPM1 and TPM2",
	lang: "ABAP"
)

= Results

In this chapter, we present the outcomes achieved throughout each stage of the development process, following the timeline and methodology outlined in chapter 3.3. The discussion progresses chronologically through the implementation phases, detailing the enhancements that have been successfully integrated into the TRM software and are currently operational in the production environment. Subsequently, we provide a comprehensive technical explanation of the modifications introduced, including their architectural design, implementation details, and integration points within the existing system.

== Building Foundational Knowledge (Week 1)

As anticipated, the majority of the first week was dedicated to research of financial terminology, conducted under the guidance of my supervisor. During this period, I investigated financial instruments, such as equities and fixed-income securities; and conducted an initial exploration of the Treasury and Risk Management application interface. Additionally, I began my introduction to ABAP programming by studying existing code implementations within the system. Through this combination of theoretical study and practical exploration, I developed a foundational understanding of the objectives and functional scope of each transaction, as well as their distinct operational requirements.

== System and Transaction Analysis (Weeks 2-3)

During this phase, I conducted an in-depth analysis of the logic underlying both transactions. This proved to be the most time-intensive part of the development process, as it required learning an unfamiliar programming language, navigating a large codebase, and working with limited documentation. As part of this analysis, I created visual representations of the transaction logic, including the diagram presented in chapter 4.1. In parallel, I focused on improving my ABAP programming skills. Following my supervisor's recommendation, I completed practical exercises, including developing a simple ABAP calculator interface. These exercises helped me apply my existing programming knowledge to the ABAP language and significantly increased my confidence in my ability to work with this technology.

== Implementation (Weeks 4-5)

Subsequently, I conducted experiments with output filtering at various levels within the code structure. This exploratory work proved instrumental in validating the centralized filtering approach that was previously discussed in this paper. Following these experiments, I proceeded to develop the initial implementation of the proposed enhancements, with particular emphasis on creating code that was maintainable, reusable, and consistent with the established standards and conventions used throughout the TRM codebase.

The first implementation of the proposed changes is presented in the following figure. This version was developed prior to receiving feedback from my supervisor. It featured a collapsible menu selection interface, which I designed to match the appearance and behavior of similar selection screens found in other transactions within the application, which served an analogous purpose. This was done with the intent of providing a consistent user experience across the system.

#linebreak()
#figure(
	image("assets/OutputControl_old.png", width: 84%),
	caption: "First Implementation"
)

== Feedback and Improvements (Week 6)

While the proposed solution and its implementation were mostly satisfactory, the feedback phase revealed two important areas that needed improvement to prevent problems down the road.

First, although the collapsible selection screen maintained consistency across the system, it was not intuitive enough. Users, especially those with visual impairments or accessibility needs, could find it confusing to navigate.

Second, since the *cl_workingstock_tlv* and *cl_protocol_tlv* classes are used in similar ways throughout the TRM application, it made sense to create a single, reusable selection screen that could be included in other transactions in the future. Similarly, creating appropriately named Domain and Data elements to store the relevant variables would make it easier to integrate similar solutions in other parts of the system later on.

Based on this feedback, I decided to implement a simpler and clearer selection screen in a reusable include file. I also created the suggested Domain and Data elements as recommended. The new design focused on making the interface more accessible and straightforward for all users. I also opted to remove the "Display Positions" option as, even when the box was unchecked, errors were still displayed in the output log, which is the case in the transactions where the original menu was found. The following figure shows the updated Output Control selection menu for TPM1, which now includes the newly implemented menu from the include file, labeled as "Protocol Display options".

#linebreak()
#figure(
	image("assets/OutputControl.png"),
	caption: "New output control menu"
)
== Documentation and Deployment (Week 7)

This week was spent primarily on creating documentation for the implemented changes. This included writing descriptions for the "F1 Help" feature, which displays additional information about the parameters on the screen to help users understand the options available. I also created SAP Notes to document the changes, allowing other teams to downport these enhancements into their own systems if needed. Additionally, this week involved releasing these changes into the development systems across various versions to ensure compatibility and proper integration. The figure below shows one of the released notes containing these changes.

#figure(
	image("assets/SAP_Note.png"),
	caption: "SAP Note"
)

== Post deployment reflection (Week 8)

Since there were no issues during release, I spent this week writing this paper and shadowing my supervisor as they handled a customer case. This gave me valuable insight into the day-to-day work done in the department. 

Reflecting on the development process, I identified several key lessons. The biggest bottleneck I encountered was the lack of documentation. Much of my time was spent trying to understand how the code worked by reading it directly, rather than finding written explanations. In future projects, I believe it would be more efficient to ask team members for clarification earlier, rather than spending extended periods trying to figure things out independently.

Secondly, while the time I spent learning financial terminology was useful for understanding the work done in this department, it had little practical benefit during the actual development process. The technical implementation did not require deep knowledge of financial concepts. In the future, I would recommend completing this type of foundational research after the development phase is finished, allowing more focused time for the technical work itself.

Finally, the experience reinforced the importance of clear communication and asking for help when needed, as well as prioritizing learning activities based on their direct relevance to the task at hand.

== Technical explanation

In this sub-chapter, I will aim to give a general overview of the most important details in respect to the implemented changes, and their underlying logic. 

#linebreak()
First, we start by declaring the parameters that will store the information obtained from the selection screen that lives in the include file. This figure shows an extract of this file.
#codefigurefile(
	"assets/tpm_protocol_display_options.typ",
	caption: "Selection screen Include file",
	lang: "ABAP"
)

#linebreak()
After this, we must ensure that these parameters reach the appropriate level of the program by creating internal attributes in the *cl_workingstock_tlv* class and implementing a setter method to populate them. This method is invoked immediately before calling the process method in each transaction. Since all variables declared in the include file exist in the same scope as the file where it is included, this approach provides sufficient access to these variables within the process method. The following extract depicts the method used to populate the newly created attributes of the aforementioned class.
#pagebreak()
#codefigurefile(
	"assets/new_main.typ",
	caption: "Exporting of selected Parameters",
	lang: "ABAP"
)

Once we have access to these parameters in the process method, we can implement the filtering by leveraging the insights gained during the analysis phase. As shown in the following extract of the updated Process method, this approach minimizes interference with other parts of the codebase and avoids unnecessary modifications to existing methods. The changes are visible in lines 7 and 20 of the extract.
#codefigurefile(
	"assets/process_new.typ",
	caption: "Modified Process method",
	lang: "ABAP"
)
#pagebreak()
#codefigurefile(
	"assets/cl_workingstock_tlv_filter_protocol.typ",
	caption: "Filter Protocol method",
	lang: "ABAP"
)
#codefigurefile(
	"assets/cl_protocol_tlv_filter_protocol.typ",
	caption: "Methods to filter all protocol handlers",
	lang: "ABAP"
)
== Impact
= Conclusion