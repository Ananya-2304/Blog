-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Sep 14, 2024 at 08:51 AM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.0.28

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `blog`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_into_emailqueue` (IN `writer_email` VARCHAR(255), IN `blog_title` VARCHAR(255), IN `comment_content` VARCHAR(2000))   BEGIN
    DECLARE email_message VARCHAR(10000);
    
    
    SET email_message = CONCAT(
        '<h1>New Comment on Your Blog Post</h1>',
        '<p>A new comment has been added to your blog post <strong>', blog_title, '</strong>:</p>',
        '<p>', comment_content, '</p>'
    );

    
    INSERT INTO email_queue (writer_email, blog_title, email_message)
    VALUES (writer_email, blog_title, email_message);
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `category`
--

CREATE TABLE `category` (
  `cid` int(11) NOT NULL,
  `name` varchar(30) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `category`
--

INSERT INTO `category` (`cid`, `name`) VALUES
(1, 'ART'),
(2, 'SCIENCE'),
(3, 'TECHNOLOGY'),
(4, 'CINEMA'),
(5, 'DESIGN'),
(6, 'FOOD');

-- --------------------------------------------------------

--
-- Table structure for table `comments`
--

CREATE TABLE `comments` (
  `id` int(11) NOT NULL,
  `content` varchar(1000) NOT NULL,
  `commentedOn` datetime NOT NULL,
  `user_id` int(11) NOT NULL,
  `post_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `comments`
--

INSERT INTO `comments` (`id`, `content`, `commentedOn`, `user_id`, `post_id`) VALUES
(1, 'very enlightening..', '2024-03-08 16:25:25', 1, 10),
(2, 'learned a lot! thanks', '2024-03-08 16:51:04', 1, 10),
(3, 'hi, great work', '2024-03-08 16:51:57', 6, 9),
(4, 'hooo', '2024-03-08 17:29:38', 1, 9),
(5, 'jooo', '2024-03-08 17:32:18', 1, 9),
(6, 'sd', '2024-03-08 17:33:34', 1, 9),
(7, 'meow', '2024-03-08 17:53:40', 1, 9),
(8, 'dscd', '2024-03-08 18:25:16', 1, 9),
(9, 'scscsc', '2024-03-08 18:53:07', 1, 9),
(10, 'hello ,how are you?', '2024-03-08 22:26:57', 1, 10),
(11, 'okay please', '2024-03-08 22:33:05', 1, 10),
(12, 'Very insightful', '2024-03-08 22:36:05', 1, 10),
(13, 'Cannot agree more', '2024-03-08 22:40:49', 1, 10),
(14, 'yessss', '2024-03-08 22:44:39', 1, 10),
(15, 'Beautiful! loved it', '2024-03-09 13:59:48', 1, 9),
(16, 'Heyy great work! learnt a lot, Thank you', '2024-03-09 22:26:32', 1, 11),
(17, 'hi nice work', '2024-03-14 11:18:19', 1, 9),
(18, 'good', '2024-03-14 12:44:31', 6, 9),
(19, 'ghgdf', '2024-03-16 11:20:17', 1, 9),
(20, 'Cannot agree with you more!!', '2024-03-23 15:19:20', 1, 23),
(21, 'Let\'s go again sometime........... XD', '2024-03-23 15:34:08', 1, 24),
(22, 'great experience!!', '2024-03-25 14:09:07', 10, 24),
(23, 'awesomee!!!', '2024-03-25 14:09:36', 10, 13),
(24, 'hello', '2024-03-25 16:19:01', 1, 12);

--
-- Triggers `comments`
--
DELIMITER $$
CREATE TRIGGER `after_comment_insert` AFTER INSERT ON `comments` FOR EACH ROW BEGIN
    
    DECLARE writer_email VARCHAR(255);
    DECLARE blog_title VARCHAR(255);
    DECLARE comment_content VARCHAR(255); 

    SELECT u.email, p.title INTO writer_email, blog_title
    FROM posts p
    JOIN user_info u ON p.user_id = u.id
    WHERE p.id = NEW.post_id;

    SET comment_content = NEW.content; 

    
    CALL insert_into_emailqueue(writer_email, blog_title, comment_content);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `email_queue`
--

CREATE TABLE `email_queue` (
  `id` int(11) NOT NULL,
  `writer_email` varchar(255) NOT NULL,
  `blog_title` varchar(255) NOT NULL,
  `email_message` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `likes`
--

CREATE TABLE `likes` (
  `id` int(11) NOT NULL,
  `userId` int(11) NOT NULL,
  `postId` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `likes`
--

INSERT INTO `likes` (`id`, `userId`, `postId`) VALUES
(13, 6, 9),
(14, 4, 9),
(15, 7, 9),
(18, 1, 10),
(21, 1, 9),
(22, 1, 11),
(23, 1, 23),
(24, 1, 24),
(25, 1, 12);

-- --------------------------------------------------------

--
-- Table structure for table `posts`
--

CREATE TABLE `posts` (
  `id` int(11) NOT NULL,
  `title` varchar(1000) NOT NULL,
  `desc` longtext NOT NULL,
  `img` varchar(255) NOT NULL,
  `date` datetime NOT NULL,
  `user_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `posts`
--

INSERT INTO `posts` (`id`, `title`, `desc`, `img`, `date`, `user_id`) VALUES
(9, 'Design', '<p>A&nbsp;design&nbsp;is a concept of or proposal for an object, a&nbsp;process, or a&nbsp;system. Design refers to something that is or has been intentionally created by a thinking agent, though it is sometimes used to refer to the nature of something – its design. The verb&nbsp;to design&nbsp;expresses the process of developing a design. In some cases, the direct construction of an object without an explicit prior plan may also be considered to be a design (such as in some artwork and craftwork).</p><p>A design is expected to have a purpose within a certain context, usually has to satisfy certain&nbsp;goals&nbsp;and constraints, and to take into account&nbsp;aesthetic, functional, economic, environmental or socio-political considerations. Typical examples of designs include&nbsp;architectural&nbsp;and&nbsp;engineering&nbsp;drawings,&nbsp;circuit diagrams,&nbsp;sewing patterns&nbsp;and less tangible artefacts such as&nbsp;business process&nbsp;models.[1]</p>', '1709878367619wp.jpg', '2024-03-06 12:23:47', 1),
(10, 'Technological benefits and roles', '<p><strong><em>Technology&nbsp;is the application of&nbsp;conceptual knowledge&nbsp;for achieving practical&nbsp;goals, especially in a&nbsp;reproducible&nbsp;way.[1]Technology plays important role in our daily life because its make our life more convenient. The word&nbsp;technology&nbsp;can also mean the products resulting from such efforts,[2][3]&nbsp;including both tangible&nbsp;tools&nbsp;such as&nbsp;utensils&nbsp;or&nbsp;machines, and intangible ones such as&nbsp;software. Technology plays a critical role in&nbsp;science,&nbsp;engineering, and&nbsp;everyday life.</em></strong></p><p><br></p><p>Technological advancements have led to significant changes in&nbsp;society. The earliest known technology is the&nbsp;stone tool, used during&nbsp;prehistoric times, followed by the&nbsp;control of fire, which contributed to the&nbsp;growth&nbsp;of the&nbsp;human brain&nbsp;and the development of&nbsp;language&nbsp;during the&nbsp;Ice Age. The invention of the&nbsp;wheel&nbsp;in the&nbsp;the&nbsp;Bronze Age&nbsp;allowed greater travel and the creation of more complex machines. More recent technological inventions, including the&nbsp;printing press, telephone, and the&nbsp;Internet, have lowered barriers to communication and ushered in the&nbsp;knowledge economy.</p><p><br></p><p><em>While technology contributes to&nbsp;economic development&nbsp;and improves human&nbsp;prosperity, it can also have negative impacts like&nbsp;pollution&nbsp;and&nbsp;resource depletion, and can cause social harms like&nbsp;technological unemployment&nbsp;resulting from&nbsp;automation. As a result, there are ongoing philosophical and&nbsp;political debates&nbsp;about the role and use of technology, the&nbsp;ethics of technology, and ways to mitigate its downsides.</em></p>', '1709873520874wallpaper.jpg', '2024-03-06 13:15:03', 1),
(11, 'AI can speed design of health software', '<p><em>Artificial intelligence helped clinicians to accelerate the design of diabetes prevention software, a new study finds.</em></p><p>Publishing online March 6 in the&nbsp;<em>Journal of Medical Internet&nbsp;Research</em>, the study examined the capabilities of a form of artificial intelligence (AI) called generative AI or GenAI, which predicts likely options for the next word in any sentence based on how billions of people used words in context on the internet. A side effect of this next-word prediction is that the generative AI \"chatbots\" like chatGPT can generate replies to questions in realistic language, and produce clear summaries of complex texts.</p><p><br></p><p>Led by researchers at NYU Langone Health, the current paper explores the application of ChatGPT to the design of a software program that uses text messages to counter diabetes by encouraging patients to eat healthier and get exercise. The team tested whether AI-enabled interchanges between doctors and software engineers could hasten the development of such a personalized automatic messaging system (PAMS).</p><p>In the current study, eleven evaluators in fields ranging from medicine to computer science successfully used ChatGPT to produce a version of the diabetes tool over 40 hours, where an original, non-AI-enabled effort had required more than 200 programmer hours.</p><p><br></p><p>\"<strong>We found that ChatGPT improves communications between technical and non-technical team members to hasten the design of computational solutions to medical problems</strong>,\" says study corresponding author Danissa Rodriguez, PhD, assistant professor in the Department of Population Health at NYU Langone, and member of its Healthcare Innovation Bridging Research, Informatics and Design (HiBRID) Lab. \"The chatbot drove rapid progress throughout the software development life cycle, from capturing original ideas, to deciding which features to include, to generating the computer code. If this proves to be effective at scale it could revolutionize healthcare software design.\"</p>', '1710004045282Screenshot (73).png', '2024-03-09 22:16:55', 1),
(12, 'A novel method for easy fabrication of biomimetic robots ', '<p><strong>Ultraviolet-laser processing is a promising technique for developing intricate microstructures, enabling complex alignment of muscle cells, required for building life-like biohybrid actuators, as shown by Tokyo Tech researchers. Compared to traditional complex methods, this innovative technique enables easy and quick fabrication of microstructures with intricate patterns for achieving different muscle cell arrangements, paving the way for biohybrid actuators capable of complex, flexible movements.</strong></p><p><br></p><p>Biomimetic robots, which mimic the movements and biological functions of living organisms, are a fascinating area of research that can not only lead to more efficient robots but also serve as a platform for understanding muscle biology. Among these, biohybrid actuators, made up of soft materials and muscular cells that can replicate the forces of actual muscles, have the potential to achieve life-like movements and functions, including self-healing, high efficiency, and high power-to-weight ratio, which have been difficult for traditional bulky robots that require heavy energy sources. One way to achieve these life-like movements is to arrange muscle cells in biohybrid actuators in an anisotropic manner. This involves aligning them in a specific pattern where they are oriented in different directions, like what is found in living organisms. While previous studies have reported biohybrid actuators with significant movement using this technique, they have mostly focused on anisotropically aligning muscle cells in a straight line, resulting in only simple motions, as opposed to the complex movement of native muscle tissues such as twisting, bending, and shrinking. Real muscle tissues have a complex arrangement of muscle cells, including curved and helical patterns.</p><p><br></p><p><em>Creating such complex arrangements requires the formation of curved microgrooves (MGs) on a substrate, which then serve as the guide for aligning muscle cells in the required patterns. Fabrication of complex MGs has been achieved by methods such as photolithography, wavy micrography and micro-contact printing. However, these methods involve multiple intricate steps and are not suitable for rapid fabrication.</em></p>', '17100033041909700_4_04.jpg', '2024-03-09 22:23:52', 1),
(13, 'Art is Divine', '<p><strong>This article is from the book&nbsp;<em>An Apostle of India’s Spiritual Culture</em>.</strong></p><p><em>ALL beings however low in evolution, all actions however trivial in their nature, all things however lifeless they may appear to be, bear the stamp of the light of the Eternal; the principle of the Beautiful is dancing in them all; the splendour of the Truth is shining equally in all creation–in the man toiling in the field, in the birds of the air, in the beasts of the forest, in the blossoms of the garden, in the waves of the sea. There is only one Law of Life that is pulsating in the veins of the contents of the entire universe. Glory to the Divine Being.</em></p><p><br></p><p>Everyone in this beautiful creation is a piece of art; all that we see is but the manifestation of His art. We are His art, vivifying His might, reflecting His beauty and expressing His grandeur. Every man has the eyes of the painter and the poet; every heart has a dormant feeling for beauty and for the awareness of perfection. Every speck of space is rich with the inexhaustible abundance of goodness, of godliness, of beauty. One has to widen one’s consciousness and deepen one’s spirit to be able to develop the vision of all spirit shining in and through matter, all reality revealing itself in and through the unreal. To escape from this world of limitations (while yet being on earth) into the boundless world of Freedom and Beauty, Power and Brilliance, is the purpose of our existence.</p>', '1711182492712desktop-wallpaper-warm-warm-scenery.jpg', '2024-03-14 11:22:02', 1),
(20, 'The Future Is Now: 6 Key Trends in Cinema', '<p>The cinema industry is constantly evolving with new technologies and changing consumer preferences shaping the way movies are made and watched.</p><p>As we look towards&nbsp;<strong>2023,</strong>&nbsp;there are&nbsp;<strong>several key trends</strong>&nbsp;that are poised to have a significant impact on the industry. From the growing popularity of streaming services, to the increased focus on premiumization and sustainability,&nbsp;<strong>these trends will shape the future of the cinema industry and determine which companies and films succeed in the coming years.</strong>&nbsp;Whether you’re a film lover, industry professional, or just curious about the future of cinema,&nbsp;<strong>these are the trends to be looking out for:</strong></p><p><strong>TL;DR</strong></p><ol><li><strong>2023 Will Reshape The Exhibition Market </strong></li><li><strong>Distribution Will Have to Change Too </strong></li><li><strong>A greater focus on ‘Premiumization’ </strong></li><li><strong>Reimagining Movie Ticket Pricing Strategies </strong></li><li><strong>Redefine the Addressable Market </strong></li><li><strong>The Sustainability Challenge </strong></li></ol><p><strong>﻿</strong></p><h3>1. 2023 Will Reshape The Exhibition Market</h3><p>The exhibition market has been forced to adapt following the events of 2020.&nbsp;<strong>Cineworld,</strong>&nbsp;the second-largest cinema chain in the world, filed for Chapter 11 bankruptcy protection in the US and has been working to find a solution.&nbsp;<strong>AMC,</strong>&nbsp;the world’s largest movie theater circuit, dodged bankruptcy by a slim margin thanks to investors and nearly acquired theaters from Cineworld.&nbsp;<strong>CGR,</strong>&nbsp;France’s second-largest exhibition chain, announced that it was up for sale, with the process currently underway.&nbsp;<strong>Vue International’s</strong>&nbsp;largest creditors converted the company’s debt into an ownership stake in the company. Additionally, the&nbsp;<strong>PVR Inox merger</strong>&nbsp;in India has been given the go-ahead. The market is in a state of flux and the outcome of these changes will greatly influence its future direction. 2023 will be a crucial year for determining the market’s trajectory.</p>', '1711182519834download.jpg', '2024-03-22 19:03:50', 1),
(23, 'Buy Once, Type Forever:', '<h2 class=\"ql-align-center\">The Case for Perpetual vs. Annual Font Licenses</h2><h3><strong>In a nutshell:</strong></h3><ul><li>Recently,&nbsp;<a href=\"https://www.reddit.com/r/typography/comments/18iaadt/whats_up_with_annual_webfont_licensing/\" rel=\"noopener noreferrer\" target=\"_blank\" style=\"color: rgb(8, 129, 120);\">annual font licenses</a>&nbsp;have become the only option for many font distributors.</li><li>Because of the way it’s presented at checkout, it’s very easy to miss that you will only be licensed for 1 year, and then have to pay again (likely more).</li><li>If you continue using after the 1-year term and don’t renew (even if you are unaware), you and your company or client may be legally liable for unspecified damages for&nbsp;<a href=\"https://creativemarket.com/blog/past-use-font-licensing\" rel=\"noopener noreferrer\" target=\"_blank\" style=\"color: rgb(8, 129, 120);\">unlicensed past use</a>.</li><li>The simple solution to this problem is to make sure your font licenses are all perpetual vs annual.</li><li>Distributors like&nbsp;<a href=\"https://creativemarket.com/\" rel=\"noopener noreferrer\" target=\"_blank\" style=\"color: rgb(8, 129, 120);\">Creative Market</a>&nbsp;and&nbsp;<a href=\"https://www.fontspring.com/\" rel=\"noopener noreferrer\" target=\"_blank\" style=\"color: rgb(8, 129, 120);\">Fontspring</a>&nbsp;offer&nbsp;<a href=\"https://www.fontspring.com/worry-free\" rel=\"noopener noreferrer\" target=\"_blank\" style=\"color: rgb(8, 129, 120);\">worry-free</a>, perpetual font licenses.</li><li>Even if the specific font you are using is only available from a distributor that insists on annual licenses,&nbsp;<a href=\"https://creativemarket.com/enterprise\" rel=\"noopener noreferrer\" target=\"_blank\" style=\"color: rgb(8, 129, 120);\">Creative Market</a>&nbsp;and&nbsp;<a href=\"https://www.fontspring.com/enterprise\" rel=\"noopener noreferrer\" target=\"_blank\" style=\"color: rgb(8, 129, 120);\">Fontspring</a>&nbsp;offer Enterprise support to help find&nbsp;<a href=\"https://creativemarket.com/alternatives/\" rel=\"noopener noreferrer\" target=\"_blank\" style=\"color: rgb(8, 129, 120);\">suitable alternatives</a>&nbsp;that can be licensed perpetually.</li></ul><p><br></p><p>From corporate branding to user interfaces, the fonts we choose can significantly impact perception and usability. However, beyond the creative decisions lies a critical legal framework governing the use of typefaces:&nbsp;<strong>font licensing.&nbsp;</strong></p><p><br></p><p><em>Navigating font licensing is essential for any organization that values legal integrity, creative excellence, and ethical responsibility. Throughout this article, we will explore the benefits of perpetual font licenses and some of the drawbacks of annual licenses.</em></p><p><br></p><h3><strong>What is a Perpetual Font License?</strong></h3><p>A perpetual font license represents a one-time investment in a typeface, granting the licensee the right to use it indefinitely without the need for renewal fees or additional payments over time. This model contrasts sharply with subscription-based or time-limited licenses, which require ongoing payments to maintain legal usage rights.&nbsp;</p><p><br></p><h3><strong>Benefits of Securing a Perpetual Font License</strong></h3><p>The perpetual license model is grounded in simplicity, predictability, and cost-effectiveness for users ranging from individual designers to large organizations. They offer a range of benefits that make them a preferred choice for many users, especially within corporate settings where long-term brand consistency, budget predictability, and legal security are paramount.&nbsp;</p><p>Let’s go over some of the benefits associated with one-time, perpetual font licenses.</p><p><br></p><h4><strong>1. Simpler Purchase Process</strong></h4><p>The process of acquiring a perpetual font license is straightforward, designed to eliminate the complexity and inconvenience associated with recurring renewals. Once the license is purchased, the font can be used indefinitely for the licensed purposes, without the need to track expiration dates or manage renewal processes. This simplicity ensures a smoother workflow and eliminates the administrative burden often associated with subscription models.</p><ul><li><strong>Predictability:&nbsp;</strong>With no need to plan for annual renewals, budgeting becomes more predictable. Designers and organizations can plan long-term projects without worrying about future license costs or availability.</li><li><strong>Simplicity:&nbsp;</strong>Choosing a perpetual license means dealing with less paperwork and fewer administrative tasks. This simplicity is especially beneficial for creative professionals and organizations who prefer to focus on their core activities rather than license management.</li></ul><p><br></p><h4><strong>2. Budget-friendly Expense</strong></h4><p>Perpetual licenses are financially advantageous, especially when considered over the lifespan of a project or the operational period of a business. By paying a one-time fee, users avoid the cumulative costs associated with recurring license fees, which can significantly increase over time.</p><ul><li><strong>Cost Efficiency:&nbsp;</strong>In the long run, perpetual licenses can be much more cost-effective than subscription models, especially for fonts that become core elements of a brand’s identity.</li><li><strong>Usage-based Scoping:</strong>&nbsp;Perpetual licenses often allow for specific usage rights customization, ensuring that organizations only pay for the access they need, without the overhead of unused services or features.</li></ul><p><br></p><h4><strong>3. Long-term Legal Coverage</strong></h4><p>Perpetual licenses offer comprehensive legal protection for the use of the font, significantly reducing the risk of copyright infringement and the associated liabilities. This&nbsp;<a href=\"https://www.fontspring.com/worry-free\" rel=\"noopener noreferrer\" target=\"_blank\" style=\"color: rgb(8, 129, 120);\">worry-free</a>&nbsp;coverage is particularly valuable for digital assets that may be widely distributed or accessible online for extended periods of time.</p><ul><li><strong>Secure Brand Assets:</strong>&nbsp;Brands can use licensed fonts with peace of mind, knowing their use complies with copyright laws, thus protecting against legal challenges.&nbsp;</li><li><strong>Reliability:&nbsp;</strong>The assurance of perpetual rights means that fonts can be used in long-term projects without the risk of losing access due to licensing changes or discontinuation of a subscription service.</li></ul><h4><strong>4. Long-term Project Friendly</strong></h4><p>For projects with a lengthy timeline or for brands looking to maintain a consistent visual identity over many years, perpetual licenses offer an ideal solution. The one-time fee model aligns perfectly with the needs of long-term projects, providing both financial and operational advantages.</p><ul><li><strong>Consistency in Branding:</strong>&nbsp;A perpetual license ensures that a brand can consistently use its chosen fonts across all mediums like social media, email, paid media, and other platforms without interruption, crucial for maintaining brand identity.</li><li><strong>Flexibility and Freedom:</strong>&nbsp;Graphic designers have the freedom to use the font across various projects over time, adapting and evolving their use as the brand or project requirements change, without the need to renegotiate licensing terms.</li></ul><p>By providing a frictionless purchase process, budget-friendly terms, long-term legal coverage, and suitability for long-term projects, perpetual licenses represent a wise investment in a brand’s visual assets. This licensing model supports the creative and strategic objectives of brands while ensuring compliance and reducing administrative burdens.</p><p><br></p><h3><strong>Upfront &amp; Worry-free: Creative Market’s Unique Approach to Font Licensing</strong></h3><p>Our approach demystifies the font licensing process, making it accessible for designers, agencies, and businesses of all sizes. At the heart of Creative Market’s licensing model is the commitment to simplicity and predictability.&nbsp;</p><h4><strong>1. Simplified Licensing Through One-time Payment</strong></h4><p>Our one-time payment structure eliminates the recurring fees and administrative overhead typically associated with font licensing. This approach not only makes financial planning more straightforward but also ensures that once you’ve licensed a font, it’s yours to use forever, without the worry of renewal deadlines or escalating costs.&nbsp;</p><ul><li><strong>No Hidden Fees:&nbsp;</strong>Transparency in pricing ensures that users know exactly what their investment entails, with no unexpected charges down the line.</li><li><strong>Ease of Management:&nbsp;</strong>Eliminating the need for ongoing license management allows designers and businesses to focus on what they do best: creating exceptional designs.</li><li><strong>No “font police”:&nbsp;</strong>We will never send you a nasty email demanding that you pay us more. We think that’s just rude!</li></ul><h4><strong>2. Enhanced Control with Self-hosting</strong></h4><p>Creative Market empowers users with self-hosted web fonts, granting unparalleled control over their online presence. This feature sidesteps the dependencies and potential vulnerabilities associated with third-party hosting solutions. By hosting fonts directly on their servers, users gain direct control over their web assets, ensuring faster load times, increased reliability, and enhanced security.</p><ul><li><strong>Direct Control:&nbsp;</strong>Manage how and when fonts are loaded, optimizing performance and aligning with your site’s specific needs.</li><li><strong>Increased Security:</strong>&nbsp;Reduce exposure to third-party outages or security breaches, keeping your digital assets safe.</li></ul><h4><strong>3. Access to Up-to-date Font Files</strong></h4><p>Our platform ensures that users always have access to the latest versions of their purchased font files. This commitment to keeping digital assets current is crucial for maintaining the compatibility and security of your projects. Whenever a Creative Market shop owner updates a font, purchasers receive immediate access to the new version, guaranteeing that your design toolkit remains at the cutting edge.</p><ul><li><strong>Seamless Updates:&nbsp;</strong>Stay up-to-date effortlessly, with the newest font versions automatically available for download.</li><li><strong>Future-proof Designs:</strong>&nbsp;Ensure your projects leverage the latest typographic innovations and improvements.</li></ul><h4><strong>4. Custom Licensing Options</strong></h4><p>Recognizing the diverse needs of our community, Creative Market offers custom licensing options that go beyond desktop font usage. Whether you’re embedding fonts in apps, integrating them into design programs, or requiring extended rights for large organizations, our licensing flexibility caters to a broad spectrum of design applications. This adaptability ensures that Creative Market’s licenses can accommodate unique project requirements that other platforms, including Adobe Fonts, might not allow.</p><ul><li><strong>Versatile Use Cases:&nbsp;</strong>Tailor your font licenses to match specific project needs, from mobile apps to corporate branding.</li><li><strong>Comprehensive Coverage:</strong>&nbsp;Secure the rights necessary for your entire organization or specific applications, without compromise.</li></ul><h3><strong>Overview of Font License Types at Creative Market</strong></h3><p>We offer a variety of licenses to match different project needs:</p><ul><li><strong>Desktop License:</strong>&nbsp;Install fonts for a set number of users, suitable for a range of projects from logos to stationery. Desktop fonts are available in TrueType (TTF) and OpenType formats (OTF).</li><li><strong>Webfont License:&nbsp;</strong>Use fonts on websites with a predefined pageview limit, employing the @font-face selector for CSS integration. Web-ready fonts are delivered in formats like&nbsp;<a href=\"https://creativemarket.com/blog/the-missing-guide-to-font-formats\" rel=\"noopener noreferrer\" target=\"_blank\" style=\"color: rgb(8, 129, 120);\">WOFF and WOFF2.</a></li><li><strong>App and Epub Licenses:</strong>&nbsp;Embed fonts in applications and digital publications (epubs), ensuring a seamless user experience.</li><li><strong>Enterprise Licenses:</strong>&nbsp;Tailored for broader usage scenarios, including digital ads and server use, to accommodate specific project requirements.<a href=\"http://creativemarket.com/enterprise#form\" rel=\"noopener noreferrer\" target=\"_blank\" style=\"color: rgb(8, 129, 120);\">&nbsp;Get in touch</a>&nbsp;with our Enterprise Sales team for details.&nbsp;</li></ul><h2><strong>Understanding Annual Font Licenses</strong></h2><p>Annual font licenses are agreements that allow users to utilize a typeface for a specific period, typically one year, after which the license must be renewed to continue legal use of the font. This model is often chosen by businesses and individuals who do not require multi-year use of a specific font, or who prefer to distribute their costs over time.</p><h3><strong>How Annual Font Licenses Work</strong></h3><ul><li><strong>Time-Bound Use:</strong>&nbsp;Licensees can use the font for the duration of the agreement, which is usually 12 months. Many sites also offer monthly rental models.</li><li><strong>Renewal Requirement:</strong>&nbsp;To maintain legal use of the font beyond the initial period, the license must be renewed annually or monthly.</li><li><strong>Variable Cost:&nbsp;</strong>The cost of renewal can vary based on changes in pricing, additional usage needs, or changes in the licensing terms.</li></ul><h3><strong>Drawbacks of Annual Font Licenses</strong></h3><p>While suitable for short-term projects, annual licenses can become costly over time and complicate long-term project management for freelancers, agencies, and their clients, leading to ongoing financial commitments. Here are some of the drawbacks you’ll want to consider as you decide if an annual font license is the best fit for your organization:</p><p><strong>Increased Long-term Costs</strong></p><p>Over time, the cumulative cost of renewing an annual license can significantly exceed the one-time fee of a perpetual license, especially if the font becomes integral to a brand’s identity or is used across multiple projects.</p><p><strong>Administrative Overhead</strong></p><p>Annual renewals require ongoing management to ensure licenses are kept up to date, creating additional administrative work. This can be particularly burdensome for small businesses or freelancers who manage multiple font licenses.</p><p><strong>Risk of Discontinuation or Price Increases</strong></p><p>There’s always a risk that a font may be discontinued, or its renewal price significantly increased, potentially disrupting ongoing projects or forcing a reevaluation of budget allocations.</p><p><strong>Impact on Client Relationships</strong></p><p>For freelancers and agencies, tying project deliverables to an annual license can complicate client relationships. The need to secure ongoing payments for font licenses can be a point of contention, potentially affecting the satisfaction and retention of clients.</p><p><strong>Challenges in Budget Planning</strong></p><p>Annual licenses complicate long-term budget planning, as the need to account for renewal fees can introduce uncertainty, especially for businesses operating with tight margins or fixed budgets.</p><p><strong>Limitations on Project Scope</strong></p><p>Annual licenses may restrict the ability to expand project scope without incurring additional licensing costs. This can limit flexibility and creativity, especially for dynamic projects that evolve over time.</p><p><strong>Dependency and Lack of Ownership</strong></p><p>This model creates a dependency on the licensing entity, with no true sense of ownership over the font. In contrast, perpetual licenses offer a sense of security and permanence, ensuring that a font remains available for use regardless of future changes in licensing policies or company direction.</p><p><strong>Barrier to Long-term Brand Consistency</strong></p><p>For brands that rely on specific fonts as part of their identity, annual licenses pose a risk to long-term consistency. The ongoing need to renew can disrupt the availability of the font, potentially forcing a reevaluation of brand guidelines.</p><p><br></p><h2><strong>Buy Once, Type Forever</strong></h2><p><em>By respecting the intellectual property rights of&nbsp;</em><a href=\"https://creativemarket.com/blog/so-you-want-to-be-a-type-designer\" rel=\"noopener noreferrer\" target=\"_blank\" style=\"color: rgb(8, 129, 120);\"><em>type designers</em></a><em>, organizations contribute to a culture of fairness and recognition for creative work. It encourages the development of new, innovative typefaces and supports the broader design community.</em></p><p><br></p><p>While<strong>&nbsp;annual font licenses</strong>&nbsp;may appear attractive for short-term projects or those with fluctuating font needs, they pose significant challenges for long-term planning, budget management, and project consistency.&nbsp;<strong>Perpetual licenses</strong>, with their one-time payment and indefinite usage rights, offer a compelling alternative for those seeking stability, predictability, and cost-effectiveness in their font licensing strategy.</p><p>We encourage you to explore Creative Market’s perpetual, one-time licenses for a vast selection of<a href=\"http://creativemarket.com/fonts\" rel=\"noopener noreferrer\" target=\"_blank\" style=\"color: rgb(8, 129, 120);\">&nbsp;popular fonts</a>. Our<a href=\"http://creativemarket.com/enterprise\" rel=\"noopener noreferrer\" target=\"_blank\" style=\"color: rgb(8, 129, 120);\">&nbsp;Enterprise Sales</a>&nbsp;team is also ready to assist with any inquiries beyond standard license offerings, ensuring you find the perfect typography solutions for your projects.</p>', '1711187262624Writing_a_letter.jpg', '2024-03-23 15:17:42', 1),
(24, 'Food Walk', '<p class=\"ql-align-justify\"><span style=\"background-color: var(--ricos-custom-p-background-color,unset);\">A food walk is a fun and enjoyable activity that involves exploring a neighborhood or city while trying out different types of food. The goal is to sample a variety of dishes and drinks from local restaurants, cafes, and food stalls, while also learning about the history and culture of the area. So join us on this </span><em style=\"background-color: var(--ricos-custom-p-background-color,unset);\">delicious journey </em><span style=\"background-color: var(--ricos-custom-p-background-color,unset);\">!</span></p><p class=\"ql-align-justify\"><br></p><p class=\"ql-align-justify\"><strong style=\"color: rgb(204, 35, 68); background-color: transparent;\"><em>Kaapi Kaatte</em></strong><span style=\"background-color: var(--ricos-custom-p-background-color,unset);\"> is one of the popular place for Breakfast alongside Kaapi (coffee) or Tea.</span></p><p class=\"ql-align-justify\"><span style=\"background-color: var(--ricos-custom-p-background-color,unset);\">One of The Pocket Friendly restaurant in entire Bangalore. In 100 ₹,will get almost all the breakfast items served here and sufficient for 2 to 3 people. </span></p><p class=\"ql-align-justify\"><br></p><p><span style=\"background-color: var(--ricos-custom-p-background-color,unset);\">For all my Bengaluru champs who share my love for a good </span><em style=\"background-color: var(--ricos-custom-p-background-color,unset);\">crispy Masala dosa</em><span style=\"background-color: var(--ricos-custom-p-background-color,unset);\">, this place is definitely going on your list. </span><strong style=\"background-color: transparent;\"><em>Love comes in all forms and shapes. So does our beloved dosa </em></strong><span style=\"background-color: var(--ricos-custom-p-background-color,unset);\">- masala dosa, rava dosa, onion dosa, set dosa, ragi dosa, godi dosa and neer dosa. But masala dosa triumphs this category!</span></p><p><br></p><p><strong style=\"color: rgb(204, 35, 68); background-color: transparent;\"><em>Shree Mahalakshmi Sweets</em></strong><span style=\"background-color: var(--ricos-custom-p-background-color,unset);\"> is a name synonymous with sweetness since 1991, with the rich experience of nearly 3 decades. </span><strong style=\"background-color: transparent;\"><em>‘Taste of Mysuru’</em></strong><span style=\"background-color: var(--ricos-custom-p-background-color,unset);\"> is the motto of this place that has rendered a heaven for everyone with a sweet tooth.</span></p><p class=\"ql-align-justify\"><span style=\"background-color: var(--ricos-custom-p-background-color,unset);\">Staying true to their motto, their </span><em style=\"background-color: var(--ricos-custom-p-background-color,unset);\">mysore pak</em><span style=\"background-color: var(--ricos-custom-p-background-color,unset);\"> exceeds every expectation.</span></p><p class=\"ql-align-justify\"><span style=\"background-color: var(--ricos-custom-p-background-color,unset);\">This is a popular sweet made from gram flour, sugar, and ghee. It originated in Mysore and is known for its rich, buttery flavor and soft, crumbly texture. </span></p><p class=\"ql-align-justify\"><br></p><p class=\"ql-align-justify\"><span style=\"background-color: var(--ricos-custom-p-background-color,unset);\">You thought that was the end of the sugar rush tour? Well, you\'d be wrong. </span></p><p class=\"ql-align-justify\"><strong style=\"color: rgb(204, 35, 68); background-color: transparent;\"><em>Kanti sweets</em></strong><span style=\"background-color: var(--ricos-custom-p-background-color,unset);\">, another sister store in the same line just few feet away awaits your presence!</span></p><p class=\"ql-align-justify\"><span style=\"background-color: var(--ricos-custom-p-background-color,unset);\">Kanti Sweets is one of the few stores in the city where specialty sweets, specific to popular festivals and their celebrations like Sankranti, Holi, Raksha Bandhan, Dusshera and Diwali are available, which makes it a popular mithai-destination despite of no loud branding or glitzy packaging but promising you all the flavors that desserts have to offer.</span></p><p class=\"ql-align-justify\"><br></p><p class=\"ql-align-justify\"><span style=\"background-color: var(--ricos-custom-p-background-color,unset);\">As a resident of Bengaluru, </span><strong style=\"background-color: transparent; color: rgb(204, 35, 68);\"><em>Kadlekai parishe </em></strong><span style=\"background-color: var(--ricos-custom-p-background-color,unset);\">is our </span><em style=\"background-color: var(--ricos-custom-p-background-color,unset);\">pride and joy</em><span style=\"background-color: var(--ricos-custom-p-background-color,unset);\">. The festival is a celebration of the harvest season of groundnuts, which are a  major crop in the region. This year\'s festival was held from November 20-22, 2022, at the Bull  Temple in Basavanagudi. It has been a huge part of everyone\'s childhood. Every kid is excited to go on the ferris wheel and try out different games that are organised on the fair days. And that\'s not all folks! Along with fun games and rides, it has a vast assortment of local food and snacks that satisfy not just our tummies but our souls too.</span></p><p class=\"ql-align-justify\"><br></p><p class=\"ql-align-justify\"><span style=\"background-color: var(--ricos-custom-p-background-color,unset);\">We went as a group of 8-9 people and we all had a blast. We started our day by checking out some  of the fun rides, which were perfect for all ages. I personally loved the giant Ferris wheel, which  gave us a stunning view of the festival from high up in the air. After working up an appetite, we started exploring the different food stalls that were set up all over  the festival. There were so many different types of snacks and street foods to try, from crispy fried  vadas to spicy masala peanuts.</span></p><p class=\"ql-align-justify\"><br></p><p><span style=\"background-color: var(--ricos-custom-p-background-color,unset);\">So, are you hungry yet? What are you waiting for? </span><strong style=\"background-color: transparent;\"><em>Go try these places now!</em></strong></p><p class=\"ql-align-justify\"><br></p><p><br></p>', '1711188137381WhatsApp Image 2024-03-23 at 3.31.59 PM.jpeg', '2024-03-23 15:32:17', 8),
(25, 'TIPS FOR WATERCOLOUR GLAZING', '<p>Watercolour has become one of the most popular and versatile painting mediums over the last few decades, and there are countless different ways to use it. One method of painting that can be easily overlooked is the watercolour glazing technique, which relies on one of watercolour’s most unique and beautiful qualities: its transparency.</p><p><br></p><h3>Tips for Watercolour Glazing</h3><h3>What is Glazing?</h3><p>In its simplest form, glazing is a form of layering. It relies on thin, even layers of transparent paint, applied one on top of another, to develop colour and tone. It is a fantastic way to build up tonal value gradually, instead of going straight in with heavy colour. By employing this method of building up transparent layers, you can achieve a sense of luminosity and depth in your paintings, as well as bringing a greater sense of colour harmony to your work.</p><p>At first glance, the characteristics of a wash and a glaze are quite similar; the main difference is their purpose. Washes are large areas of paint that are laid down to create the overall sense of tone or colour. Glazes tend to be transparent layers of paint applied over existing parts of a painting that have already dried, to enhance the tone or change the colour of the underlying layer. They can be mixed from both pan and tube watercolour paint.</p><p><br></p><h3>Transparency and Opacity</h3><p>As this process relies on the transparency of the medium, it is important to check the transparency rating of your colours before you begin. Generally speaking, most watercolour paints will provide this on their packaging and will sit somewhere within the range of: Transparent, Semi-Transparent, Semi-Opaque, and Opaque. As a general rule of thumb, transparent pigments are the best to use for glazing and layering, as they allow the underlying colours to shine through.</p>', '1711351452516download (1).jpg', '2024-03-25 12:54:12', 10);

-- --------------------------------------------------------

--
-- Table structure for table `post_category`
--

CREATE TABLE `post_category` (
  `post_id` int(11) NOT NULL,
  `cat_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `post_category`
--

INSERT INTO `post_category` (`post_id`, `cat_id`) VALUES
(9, 3),
(10, 3),
(11, 3),
(12, 2),
(13, 1),
(20, 4),
(23, 5),
(24, 6),
(25, 1);

-- --------------------------------------------------------

--
-- Table structure for table `user_info`
--

CREATE TABLE `user_info` (
  `id` int(11) NOT NULL,
  `username` varchar(45) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `img` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user_info`
--

INSERT INTO `user_info` (`id`, `username`, `email`, `password`, `img`) VALUES
(1, 'ananya', 'anidoodle2020@gmail.com', '$2a$10$Xh4Q5knv3A22Vd1SHc5eHe9G91uPRR/oK12q8YgPEhqRzXGLpNjiK', NULL),
(2, 'ayush', 'user@gmail.com', '$2a$10$6EFRy6SKNUn.HJJjvidazeQbSsYY3SByz0hpusYoVl3h69FsIsSpW', NULL),
(3, 'admin5', 'test@gmail.com', '$2a$10$UjapfzmFtM9sKxj.qMc2R.16WgC5zp6rBITr9YGUzHZtd/.LO.M1u', NULL),
(4, 'bk', 'bk@hotmail.com', '$2a$10$z881vPuZmWNU8Dy02QKfpOdJajKtmO/h/bRphXiC3dEix4DfvySFq', NULL),
(5, 'akash', 'ak@gmail.com', '$2a$10$keV/i4HSNrzZzG37nmSCneqZA1jHZGGbaDqAFeEN8eR8CXpocbtUq', NULL),
(6, 'asha', 'anidoodle2020@gmail.com', '$2a$10$5OAYr0ua5m20L6tdUobmq.5AgtZovnY2Cn9lNkO5ScNOtPQPrDvxC', NULL),
(7, 'rahul', 'rrb2@gmail.com', '$2a$10$sI.yUyatmQIa9MVDV5wWB.VrBfnJOOKm14gFBBdiRfUA0buh76uEC', NULL),
(8, 'akhila', 'akhilaraichur@gmail.com ', '$2a$10$p.Dk7fxLwvzan0Oqfo4GKOeX950/P543E6/NQ2fIj/C7iobJRAnIC', NULL),
(9, 'aisha', 'aishapatil14542@gmail.com', '$2a$10$rSj7MUC99I7d.q04AggwkOxx9LxlXMdhk7/qQG3dWW62arG2fgO6y', NULL),
(10, 'ashwinikrishnajirao', 'ashwinikrishnajirao@gmail.com', '$2a$10$m6oU7ckzB4mh1hN2qXzlpe43tibmIPc.tA8kILNLKZi6l5gnD8h42', NULL);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `category`
--
ALTER TABLE `category`
  ADD PRIMARY KEY (`cid`);

--
-- Indexes for table `comments`
--
ALTER TABLE `comments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `post_id` (`post_id`);

--
-- Indexes for table `email_queue`
--
ALTER TABLE `email_queue`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `likes`
--
ALTER TABLE `likes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `postId` (`postId`),
  ADD KEY `userId` (`userId`);

--
-- Indexes for table `posts`
--
ALTER TABLE `posts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `post_category`
--
ALTER TABLE `post_category`
  ADD PRIMARY KEY (`post_id`,`cat_id`),
  ADD KEY `cat_id` (`cat_id`);

--
-- Indexes for table `user_info`
--
ALTER TABLE `user_info`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `comments`
--
ALTER TABLE `comments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT for table `email_queue`
--
ALTER TABLE `email_queue`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `likes`
--
ALTER TABLE `likes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT for table `posts`
--
ALTER TABLE `posts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT for table `user_info`
--
ALTER TABLE `user_info`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `comments`
--
ALTER TABLE `comments`
  ADD CONSTRAINT `comments_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user_info` (`id`),
  ADD CONSTRAINT `comments_ibfk_2` FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`);

--
-- Constraints for table `likes`
--
ALTER TABLE `likes`
  ADD CONSTRAINT `likes_ibfk_1` FOREIGN KEY (`postId`) REFERENCES `posts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `likes_ibfk_2` FOREIGN KEY (`userId`) REFERENCES `user_info` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `posts`
--
ALTER TABLE `posts`
  ADD CONSTRAINT `posts_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user_info` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `post_category`
--
ALTER TABLE `post_category`
  ADD CONSTRAINT `post_category_ibfk_1` FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`),
  ADD CONSTRAINT `post_category_ibfk_2` FOREIGN KEY (`cat_id`) REFERENCES `category` (`cid`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
