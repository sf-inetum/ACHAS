/*
* @description: Clase de Constantes utilizadas por el proyecto de ESACHS
* @author: Nuria Durán Rodríguez (INETUM)
* @version: 1.0 
*/
public with sharing class ESACHS_Constantes {
    // Constantes para ESACHS_HandlerLead
    public static final String ESACHS_VENTAS_RT = 'ESACHS_Ventas';
    public static final String LEAD_SOURCE_WEB = 'Web';
    public static final String CENTRO_SALUD = 'Centro de Salud';
    public static final String VSC_LARGO = 'VSC Largo';
    public static final String VSC_CORTO = 'VSC Corto';
    public static final String STATUS_CONVERTIDO = 'Convertido';
    public static final String STATUS_DESCARTADO = 'Descartado';
    
    //Constantes para el ESACHS_HandlerLead_test. Simulo JSON que viene del formulario WEB
    public static final String PRODUCTOS_CENTRO_SALUD = '[{"tipo":"Centro de Salud","producto":"Servicio Requerido","valor":"Centro de Salud"},{"tipo":"Centro de Salud","producto":"Ambulancia de Emergencia Básica 4x2","valor":"1"},{"tipo":"Centro de Salud","producto":"Ambulancia de Emergencia Básica 4x4","valor":"1"},{"tipo":"Centro de Salud","producto":"Camioneta 4x4","valor":"1"},{"tipo":"Centro de Salud","producto":"Sala de Rayos","valor":"1"},{"tipo":"Centro de Salud","producto":"Paramédico","valor":""},{"tipo":"Centro de Salud","producto":"Conductor","valor":""},{"tipo":"Centro de Salud","producto":"Enfermera","valor":""},{"tipo":"Centro de Salud","producto":"Médico","valor":""},{"tipo":"Centro de Salud","producto":"Administrador de Contrato","valor":""},{"tipo":"Centro de Salud","producto":"Prevencionista","valor":""},{"tipo":"Centro de Salud","producto":"Sistema de Turno","valor":"7x7"},{"tipo":"Centro de Salud","producto":"Jornada","valor":"Diurna"},{"tipo":"Centro de Salud","producto":"Horario Inicio Jornada","valor":"7"},{"tipo":"Centro de Salud","producto":"Horario Término Jornada","valor":"1"},{"tipo":"Centro de Salud","producto":"Infraestructura para Centro de Salud","valor":"true"},{"tipo":"Centro de Salud","producto":"Alojamiento","valor":"false"},{"tipo":"Centro de Salud","producto":"Alimentación","valor":"true"},{"tipo":"Centro de Salud","producto":"Traslado desde/hacia Ciudad más Cercana","valor":"false"},{"tipo":"Centro de Salud","producto":"Combustible para Móviles","valor":"false"}]';
    public static final String PRODUCTOS_VSC_LARGO = '[{"tipo":"VSC Largo","producto":"Programa de Seguridad Preventivos","valor":"1"},{"tipo":"VSC Largo","producto":"Programa de Calidad de Vida","valor":""},{"tipo":"VSC Largo","producto":"Programa de Salud (FyS)","valor":""},{"tipo":"VSC Largo","producto":"Programa de Inclusión","valor":""},{"tipo":"VSC Largo","producto":"Programa Hipobaria Intermitente Crónica","valor":""},{"tipo":"VSC Corto","producto":"Operativos Cardiovasculares","valor":""},{"tipo":"VSC Corto","producto":"Operativos Nutricional","valor":""},{"tipo":"VSC Corto","producto":"Masajes en Sillas","valor":""},{"tipo":"VSC Corto","producto":"Pausas Activas","valor":""},{"tipo":"VSC Corto","producto":"Yoga","valor":""},{"tipo":"VSC Corto","producto":"Terapia Kinésica","valor":""},{"tipo":"VSC Corto","producto":"Masoterapia","valor":""},{"tipo":"VSC Corto","producto":"Promoción de Estilos de Vida Saludables","valor":""},{"tipo":"VSC Corto","producto":"SEL Terreno","valor":""},{"tipo":"VSC Corto","producto":"Vacunas","valor":""},{"tipo":"VSC Corto","producto":"Servicios de Seguridad Preventiva","valor":""},{"tipo":"VSC Corto","producto":"Programa de Alcohol y Drogas","valor":""}]';
    public static final String PRODUCTOS_VSC_CORTO = '[{"tipo":"VSC Largo","producto":"Programa de Seguridad Preventivos","valor":""},{"tipo":"VSC Largo","producto":"Programa de Calidad de Vida","valor":""},{"tipo":"VSC Largo","producto":"Programa de Salud (FyS)","valor":""},{"tipo":"VSC Largo","producto":"Programa de Inclusión","valor":""},{"tipo":"VSC Largo","producto":"Programa Hipobaria Intermitente Crónica","valor":""},{"tipo":"VSC Corto","producto":"Operativos Cardiovasculares","valor":"1"},{"tipo":"VSC Corto","producto":"Operativos Nutricional","valor":""},{"tipo":"VSC Corto","producto":"Masajes en Sillas","valor":""},{"tipo":"VSC Corto","producto":"Pausas Activas","valor":""},{"tipo":"VSC Corto","producto":"Yoga","valor":""},{"tipo":"VSC Corto","producto":"Terapia Kinésica","valor":""},{"tipo":"VSC Corto","producto":"Masoterapia","valor":""},{"tipo":"VSC Corto","producto":"Promoción de Estilos de Vida Saludables","valor":""},{"tipo":"VSC Corto","producto":"SEL Terreno","valor":"1"},{"tipo":"VSC Corto","producto":"Vacunas","valor":"1"},{"tipo":"VSC Corto","producto":"Servicios de Seguridad Preventiva","valor":""},{"tipo":"VSC Corto","producto":"Programa de Alcohol y Drogas","valor":""}]';
    
    //Constantes para ESACHS_AsignAutoProspectoNoGestion_sch
    public static final String QUEUE = 'Queue';
    public static final String ESACHS_GERENCIA = 'ESACHS_Gerencia';

    //Constantes ESACHS_AutoApproveLead_sch
    public static final String ESACHS_FACTIBILIDAD= 'ESACHS_Factibilidad';
    public static final String ESACHS_CALIFICADO= 'ESACHS_Calificado';

    //Constantes ESACHS_AutoApproveLead_test
    public static final String ESACHS_VALIDACIONINFORMACION= 'ESACHS_ValidacionDeInformacion';
    
    //Constantes ESACHS_NotificacionCierreProspecto_sch
    public static final String ESACHS_PROSPECTOS_ESACHS = 'ESACHS_ProspectosESACHS';
}